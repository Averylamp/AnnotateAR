//
//  ViewController+DataManagerDelegate.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

let animationDuration = 0.5
extension ViewController:DataManagerDelegate{
    
    func nextState(){
        switch DataManager.shared().state {
        case .HostClientSelector:
            print("Host Client selector")
            if !self.view.subviews.contains(hostClientVC.view) || hostClientVC.view.isUserInteractionEnabled == false{
                
                hostClientVC.view.center = self.view.center
                hostClientVC.view.alpha = 0.0
                hostClientVC.view.center.y += 20
                hostClientVC.view.isUserInteractionEnabled = true
                blockInteraction()
                UIView.animate(withDuration: animationDuration, animations: {
                    self.hostClientVC.view.center.y -= 20
                    self.hostClientVC.view.alpha = 1.0
                }) { (finished) in
                    
                }
                
            }
        case .FindCenter:
            print("Find Center State")
            presentPrompt(text: "Find the center point of the demo.  (The host will have set the location)", confirmation: "Got it!", height: 250)
        case .Demo:
            print("Demo Time")
            addTestRoot()
            addTestObject(name:"ship")
        default:
            print("Missing something")
        }
        
        
    }
    
    func presentPrompt(text:String, confirmation:String, height: CGFloat){
        if !self.view.subviews.contains(promptVC.view) || promptVC.view.isUserInteractionEnabled == false{
            promptVC.setupPrompt(mainText: text, confirmationText: confirmation)
            promptVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: height)
            promptVC.view.center = self.view.center
            promptVC.view.alpha = 0.0
            promptVC.view.center.y += 20
            promptVC.view.isUserInteractionEnabled = true
            blockInteraction()
            UIView.animate(withDuration: animationDuration, animations: {
                self.promptVC.view.center.y -= 20
                self.promptVC.view.alpha = 1.0
            }) { (finished) in
                
            }
            
        }
        
    }
    
    func blockInteraction(){
        UIView.animate(withDuration: animationDuration) {
            self.blockingBlurView.alpha = 1.0
            self.blockingBlurView.isUserInteractionEnabled = true
        }
    }
    
    func unblockInteraction(){
        UIView.animate(withDuration: animationDuration) {
            self.blockingBlurView.alpha = 0.0
            self.blockingBlurView.isUserInteractionEnabled = false
        }
    }
    
    
    func receivedObjectsUpdate(objects: [ARObject]){
        
    }
    
    func receivedNewObject(object: ARObject){
        
    }
    
    func newDevicesConnected(devices: [String]){
        
    }
    
    
}
