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
let hideModelOptionsNotificationName = Notification.Name("HideModelOptionsNotification")
let moveModelOptionsNotificationName = Notification.Name("MoveModelOptionsNotification")
let deleteModelOptionsNotificationName = Notification.Name("DeleteModelOptionsNotification")
extension ViewController{

    func initializeObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissHostClientVC), name: hideHostClientNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissPromptVC), name: hidePromptNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissModelOptionsVC), name: hideModelOptionsNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setupCurrentObjectForMoving(notification:)), name: moveModelOptionsNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.deleteCurrentObject(notification:)), name: deleteModelOptionsNotificationName, object: nil)
        
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
    
    @objc func dismissModelOptionsVC(){
        if self.view.subviews.contains(modelOptionsVC.view){
            modelOptionsVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.modelOptionsVC.view.center.y -= 30
                self.modelOptionsVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
        }
    }
    
    @objc func setupCurrentObjectForMoving(notification: NSNotification){
        if let userInfo = notification.userInfo, let node = userInfo["model"] as? ARObjectNode, let pointOfView = self.sceneView.pointOfView{
            
            DataManager.shared().displayLink.isPaused = false
            let transform = pointOfView.convertTransform(node.transform, from: node.parent)
            node.transform = transform
            node.removeFromParentNode()
            pointOfView.addChildNode(node)
        }
    }
    
    @objc func deleteCurrentObject(notification: NSNotification){
        
    }
    
    
}
