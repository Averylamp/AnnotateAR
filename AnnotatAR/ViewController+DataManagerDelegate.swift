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
            }
        case .FindCenter:
            print("Missing something")
        default:
            print("Missing something")
        }
        
        
    }
    
    
    func receivedObjectsUpdate(objects: [ARObject]){
        
    }
    
    func receivedNewObject(object: ARObject){
        
    }
    
    func newDevicesConnected(devices: [String]){
        
    }
    
    
}
