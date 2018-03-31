//
//  ViewController+DataManagerDelegate.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

extension ViewController:DataManagerDelegate{
    
    func nextState(){
        switch DataManager.shared().state {
        case .HostClientSelector:
            print("Host Client selector")
            if !self.view.subviews.contains(hostClientVC.view){
                self.addChildViewController(hostClientVC)
                self.view.addSubview(hostClientVC.view)
                hostClientVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
                hostClientVC.view.center = self.view.center
                hostClientVC.view.alpha = 0.0
                hostClientVC.view.center.y += 20
                hostClientVC.view.isUserInteractionEnabled = true
                blockInteraction()
                UIView.animate(withDuration: 0.5, animations: {
                    self.hostClientVC.view.center.y -= 20
                    self.hostClientVC.view.alpha = 1.0
                }) { (finished) in
                    
                }
                
            }
        case .FindCenter:
            print("Missing something")
        default:
            print("Missing something")
        }
        
        
    }
    
    func blockInteraction(){
        UIView.animate(withDuration: 0.5) {
            self.blockingBlurView.alpha = 1.0
            self.blockingBlurView.isUserInteractionEnabled = true
        }
    }
    
    func unblockInteraction(){
        UIView.animate(withDuration: 0.5) {
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
