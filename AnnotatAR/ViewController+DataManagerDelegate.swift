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
            addCenteredRoot()
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
            }else{
                print("Requesting All Objects")
                DataManager.shared().requestAllObjects()
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
        DispatchQueue.main.async {
            if !self.view.subviews.contains(self.promptVC.view) ||
                self.promptVC.view.isUserInteractionEnabled == false{
                self.promptVC.setupPrompt(mainText: text, confirmationText: confirmation)
                self.promptVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: height)
                self.promptVC.view.center = self.view.center
                self.promptVC.view.alpha = 0.0
                self.promptVC.view.center.y += 20
                self.promptVC.view.isUserInteractionEnabled = true
                self.blockInteraction()
                UIView.animate(withDuration: animationDuration, animations: {
                    self.promptVC.view.center.y -= 20
                    self.promptVC.view.alpha = 1.0
                }) { (finished) in
                }
            }
        }
    }
    
    func presentWolframAlphaVC(){
        if !self.view.subviews.contains(WolframAlphaVC.view) ||
            WolframAlphaVC.view.isUserInteractionEnabled == false{
            WolframAlphaVC.view.center = self.view.center
            WolframAlphaVC.view.alpha = 0.0
            WolframAlphaVC.view.center.y -= 50
            WolframAlphaVC.view.isUserInteractionEnabled = true
            blockInteraction()
            UIView.animate(withDuration: animationDuration) {
                self.WolframAlphaVC.view.center.y -= 20
                self.WolframAlphaVC.view.alpha = 1.0
            }
        }
    }
    
    func presentTextPromptVC(){
        if !self.view.subviews.contains(textPromptVC.view) ||
            textPromptVC.view.isUserInteractionEnabled == false{
            textPromptVC.view.center = self.view.center
            textPromptVC.view.alpha = 0.0
            textPromptVC.view.center.y -= 50
            textPromptVC.view.isUserInteractionEnabled = true
            blockInteraction()
            UIView.animate(withDuration: animationDuration) {
                self.textPromptVC.view.center.y -= 20
                self.textPromptVC.view.alpha = 1.0
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
        statusViewController.showMessage("Received new obejct: \(object.modelName) ")
        print("Received Object")
        if let root = DataManager.shared().rootNode{
            if root.childNode(withName: object.name!, recursively: true) == nil{
                object.setupNode()
                root.addChildNode(object)
            }
        }
    }
    
    func newDevicesConnected(devices: [String]){
        print("New Devices Connected")
        if devices.count > 1{
            self.statusViewController.stateLabel.text = "Devices: \(devices.count + 1)"
            self.statusViewController.showMessage("Devices connected: \(devices.joined(separator: ", "))")
        }else{
            self.statusViewController.stateLabel.text = "Devices: \(devices.count + 1)"
            
            self.statusViewController.showMessage("Device connected: \(devices.joined(separator: ", "))")
        }
    }
    
    
}
