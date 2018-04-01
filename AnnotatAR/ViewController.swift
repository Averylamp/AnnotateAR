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
    let WolframAlphaVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WolframAlphaVC") as! WolframAlphaPromptController
    let textPromptVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextPromptVC") as! TextPromptViewController
    
    let menuVC = MenuViewController()
    
    var firstOpen = true
    
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
//        menuVC.view.addGestureRecognizer(panelPanGestureRecognizer)
//        panelPanGestureRecognizer.isEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(gestureRecognizer:)))
        tapGestureRecognizer.delegate = self
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinch(gestureRecognizer:)))
        pinchGestureRecognizer.delegate = self
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
    
        let rotationGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleRotateGesture(gestureRecognizer:)))
        rotationGestureRecognizer.delegate = self
        rotationGestureRecognizer.minimumNumberOfTouches = 2
        rotationGestureRecognizer.maximumNumberOfTouches = 2
        self.sceneView.addGestureRecognizer(rotationGestureRecognizer)
        
        let upDownGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleUpDownGesture(gestureRecognizer:)))
        upDownGestureRecognizer.delegate = self
        upDownGestureRecognizer.minimumNumberOfTouches = 3
        upDownGestureRecognizer.minimumNumberOfTouches = 3
        self.sceneView.addGestureRecognizer(upDownGestureRecognizer)
        
        instantiatePopoverViewControllers()
        
        colorPaletteButton.tintColor = colors[colorIndex % colors.count].withAlphaComponent(0.5)
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
        print(self.view.frame)
        menuVC.view.frame = CGRect(x: 0, y: self.view.frame.height - MenuViewController.heightOfExpandButton, width: self.view.frame.width, height: MenuViewController.heightOfView)
        menuVC.delegate = self
        
        self.addChildViewController(modelOptionsVC)
        self.view.addSubview(modelOptionsVC.view)
        modelOptionsVC.view.alpha = 0.0
        modelOptionsVC.view.isUserInteractionEnabled = false
        modelOptionsVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        
        self.addChildViewController(WolframAlphaVC)
        self.view.addSubview(WolframAlphaVC.view)
        WolframAlphaVC.view.alpha = 0.0
        WolframAlphaVC.view.isUserInteractionEnabled = false
        WolframAlphaVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        self.addChildViewController(textPromptVC)
        self.view.addSubview(textPromptVC.view)
        textPromptVC.view.alpha = 0.0
        textPromptVC.view.isUserInteractionEnabled = false
        textPromptVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstOpen{
            let splashScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC")
            self.present(splashScreenVC, animated: false)
            firstOpen = false
        }
		
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
        
        if let root = DataManager.shared().rootNode{
            root.removeFromParentNode()
            DataManager.shared().rootNode = nil
        }
        
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
            
            self.addRootNode(imageNode: node)
            if (DataManager.shared().state == State.FindCenter){
                DataManager.shared().state = State.Demo
                self.nextState()
            }
        }

        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }
    
    func addRootNode(imageNode: SCNNode){
        if let root = DataManager.shared().rootNode{
            print("Removing root node")
            root.childNodes.forEach{
                $0.removeFromParentNode()
            }
        }
        print("Adding root node")
        let pointNode = SCNNode()
        let pointGeometry = SCNSphere(radius: 0.01)
        let orangeMaterial = SCNMaterial()
        orangeMaterial.diffuse.contents = UIColor.orange
        pointGeometry.materials = [orangeMaterial]
        pointNode.geometry = pointGeometry
        let transform = self.sceneView.scene.rootNode.convertTransform(imageNode.transform, to: self.sceneView.scene.rootNode)
        pointNode.transform = transform
        self.sceneView.scene.rootNode.addChildNode(pointNode)
        DataManager.shared().rootNode = pointNode
        DataManager.shared().requestAllObjects()
    }

    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.35),
            .fadeOpacity(to: 0.15, duration: 0.35),
            .fadeOpacity(to: 0.85, duration: 0.35),
            .fadeOpacity(to: 0.15, duration: 0.35),
            .fadeOpacity(to: 0.85, duration: 0.35),
            .fadeOpacity(to: 0.15, duration: 0.35),
            .fadeOpacity(to: 0.85, duration: 0.35),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }

    @IBOutlet weak var colorPaletteButton: UIButton!
    
    var colorIndex = 0
    
    @IBAction func addAnnotation(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            let node = ARObjectNode(modelName: "Pointer", colorID: colorIndex % colors.count)
            node.setupNode()
            self.addARObjectNode(node: node)
        case 101:
            let node = ARObjectNode(modelName: "Circle", colorID: colorIndex % colors.count)
            node.setupNode()
            self.addARObjectNode(node: node)
        case 102:
            self.presentTextPromptVC()
        case 103:
            self.presentWolframAlphaVC()
        case 104:
            colorIndex += 1
            colorPaletteButton.tintColor = colors[colorIndex % colors.count].withAlphaComponent(0.5)
        default:
            print("Unknown annotation")
        }
    }
    
    
}
