//
//  SplashScreenViewController.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import LTMorphingLabel

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var clientButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.animate(withDuration: 1.0) {
            self.mainLogo.center.y -= 100
        }
        self.delay(0.5) {
            UIView.animate(withDuration: 1.0, animations: {
                self.definitionLabel.alpha = 1.0
            })
        }
        
        self.delay(2.0) {
            UIView.animate(withDuration: 1.0, animations: {
                self.clientButton.alpha = 1.0
            })
        }
        self.delay(3.0) {
            UIView.animate(withDuration: 1.0, animations: {
                self.hostButton.alpha = 1.0
            })
        }
    }
    
    @IBAction func clientClicked(_ sender: Any) {
        DataManager.shared().userType = .Client
        DataManager.shared().state = .FindCenter
        DataManager.shared().connectivity.startBrowsing()
        
        NotificationCenter.default.post(name: hideHostClientNotificationName, object: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hostClicked(_ sender: Any) {
        DataManager.shared().userType = .Host
        DataManager.shared().state = .FindCenter
        DataManager.shared().connectivity.startAdvertising()
        
        NotificationCenter.default.post(name: hideHostClientNotificationName, object: self)
        self.dismiss(animated: true, completion: nil)
    }
}
