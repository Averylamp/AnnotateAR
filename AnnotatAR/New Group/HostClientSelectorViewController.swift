//
//  HostClientSelectorViewController.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

class HostClientSelectorViewController: UIViewController {

    var isDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hostButtonClicked(_ sender: Any) {
        DataManager.shared().userType = .Host
        DataManager.shared().connectivity.startAdvertising()
        
        NotificationCenter.default.post(name: hideHostClientNotificationName, object: self)
    }
    
    @IBAction func clientButtonClicked(_ sender: Any) {
        DataManager.shared().userType = .Client
        DataManager.shared().connectivity.startBrowsing()
        
        NotificationCenter.default.post(name: hideHostClientNotificationName, object: self)
    }
    
}
