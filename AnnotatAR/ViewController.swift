/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var blockingBlurView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    let hostClientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HostClientVC") as! HostClientSelectorViewController
    let promptVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PromptVC") as! PromptViewController
    let modelOptionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModelOptionsVC") as! ModelOptionsPromptViewController
    
    let menuVC = MenuViewController()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        DataManager.shared().delegate = self
        self.initializeObservers()
        
        blockingBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blockingBlurView.frame = self.view.frame
        blockingBlurView.alpha = 0.0
        blockingBlurView.isUserInteractionEnabled = false
        self.view.addSubview(blockingBlurView)
        
        let panelPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePanGesture(_:)))
        panelPanGestureRecognizer.delegate = self
        menuVC.view.addGestureRecognizer(panelPanGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(gestureRecognizer:)))
        tapGestureRecognizer.delegate = self
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        instantiatePopoverViewControllers()
        
    }
    
    func instantiatePopoverViewControllers(){
        self.addChildViewController(hostClientVC)
        self.view.addSubview(hostClientVC.view)
        hostClientVC.view.alpha = 0.0
        hostClientVC.view.isUserInteractionEnabled = false
        hostClientVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        
        self.addChildViewController(promptVC)
        self.view.addSubview(promptVC.view)
        promptVC.view.alpha = 0.0
        promptVC.view.isUserInteractionEnabled = false
        promptVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        
        self.addChildViewController(menuVC)
        self.view.insertSubview(menuVC.view, belowSubview: blockingBlurView)
        menuVC.view.frame = CGRect(x: CGFloat(0), y: self.view.frame.height - MenuViewController.heightOfExpandButton, width: self.view.frame.height, height: MenuViewController.heightOfView)
        menuVC.delegate = self
        
        self.addChildViewController(modelOptionsVC)
        self.view.addSubview(modelOptionsVC.view)
        modelOptionsVC.view.alpha = 0.0
        modelOptionsVC.view.isUserInteractionEnabled = false
        modelOptionsVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}

    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true

    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
	func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.isAutoFocusEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        statusViewController.scheduleMessage("All set for AR", inSeconds: 5.5, messageType: .contentPlacement)
        
        DataManager.shared().state = DataManager.shared().initialState
        
        nextState()
        
	}

    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        updateQueue.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }

        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }

    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
    
    @IBAction func testButtonClicked(_ sender: Any) {
        self.addTestObject(name: "Drone")
    }
    
}
