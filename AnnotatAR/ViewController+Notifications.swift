//
//  ViewController+Notifications.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

let hideHostClientNotificationName = Notification.Name("HideHostClientNotification")
let hidePromptNotificationName = Notification.Name("HidePromptNotification")
extension ViewController{

    func initializeObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissHostClientVC), name: hideHostClientNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissPromptVC), name: hidePromptNotificationName, object: nil)
        
    }

    @objc func dismissHostClientVC(){
        if self.view.subviews.contains(hostClientVC.view){
            hostClientVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.hostClientVC.view.center.y -= 30
                self.hostClientVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
            self.delay(2.0) {
                self.nextState()
            }
        }
    }
    
    @objc func dismissPromptVC(){
        if self.view.subviews.contains(promptVC.view){
            promptVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.promptVC.view.center.y -= 30
                self.promptVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
        }
        
    }
    
    
}
