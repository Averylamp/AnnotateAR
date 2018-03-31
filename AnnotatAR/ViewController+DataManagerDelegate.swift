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
            addTestRoot()
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
            if DataManager.shared().userType == .Host{
//                addTestObject(name:"ship")
            }
        default:
            print("Missing something")
        }
    }
    
    func promptModelOptions(model:ARObjectNode){
        if !self.view.subviews.contains(modelOptionsVC.view) ||
            modelOptionsVC.view.isUserInteractionEnabled == false{
            modelOptionsVC.view.center = self.view.center
            modelOptionsVC.view.alpha = 0.0
            modelOptionsVC.view.center.y += 20
            modelOptionsVC.view.isUserInteractionEnabled = true
            modelOptionsVC.setModel(model: model)
            blockInteraction()
            UIView.animate(withDuration: animationDuration) {
                self.modelOptionsVC.view.center.y -= 20
                self.modelOptionsVC.view.alpha = 1.0
            }
        }
    }
    
    func presentPrompt(text:String, confirmation:String, height: CGFloat){
        if !self.view.subviews.contains(promptVC.view) ||
            promptVC.view.isUserInteractionEnabled == false{
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
    
    
    func receivedObjectsUpdate(objects: [ARObjectNode]){
        print("Received Objects")
    }
    
    func receivedNewObject(object: ARObjectNode){
        statusViewController.showMessage("Received new obejct: \(object.name) ")
        print("Received Object")
        if let root = DataManager.shared().rootNode{
            if root.childNode(withName: object.name!, recursively: true) == nil{
                object.load()
                root.addChildNode(object)
            }
        }
    }
    
    func newDevicesConnected(devices: [String]){
        print("New Devices Connected")
        if devices.count > 1{
            self.statusViewController.showMessage("Devices connected: \(devices.joined(separator: ", "))")
        }else{
            self.statusViewController.showMessage("Device connected: \(devices.joined(separator: ", "))")
        }
    }
    
    
}
