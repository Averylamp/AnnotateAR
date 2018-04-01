//
//  ViewController+Demo.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import SceneKit

extension ViewController{
    
    func addCenteredRoot(){
        return
        if DataManager.shared().rootNode == nil{
            let pointNode = SCNNode()
            let pointGeometry = SCNSphere(radius: 0.01)
            let orangeMaterial = SCNMaterial()
            orangeMaterial.diffuse.contents = UIColor.orange
            pointGeometry.materials = [orangeMaterial]
            pointNode.geometry = pointGeometry
            pointNode.position = SCNVector3.init(0, 0, -1)
            self.sceneView.scene.rootNode.addChildNode(pointNode)
            DataManager.shared().rootNode = pointNode
        }
    }
    
    func addARObjectNode(node: ARObjectNode){
        var distance:Float = 1
        if let root = DataManager.shared().rootNode,
            let cameraNode = self.sceneView.pointOfView{
            let distance_x = abs(root.position.x - cameraNode.position.x)
            let distance_z = abs(root.position.z - cameraNode.position.z)
            print("Distance x: \(distance_x), y: \(distance_z)")
            let fullDistance  = sqrt(distance_x * distance_x + distance_z * distance_z)
            distance = fullDistance
        }
        node.position = SCNVector3Make(0, 0, -distance)
        
        self.sceneView.pointOfView?.addChildNode(node)
        DataManager.shared().addObject(object: node)
        
    }
    
    func addWolframAlphaNode(image:UIImage){
        
        
    }
    
    
    func demoScreenTapped(gestureRecognizer: UITapGestureRecognizer){
        if DataManager.shared().currentObjectMoving != nil {
            print("Lock node called")
            DataManager.shared().lockCurrentMovingObject()
        }else{
            if DataManager.shared().userType == .Client{
                return
            }
            // Must have clicked on the object
            
            let location = gestureRecognizer.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            guard let tappedNode = hits.first?.node else {
                print("tapped, but not on node")
                return
            } //if it didn't hit anything, just return
            
            var rootTappedNode = tappedNode
            
            while true {
                guard let tempParent = rootTappedNode.parent else { break }
                if (DataManager.shared().rootNode == tempParent) {
                    break
                } else {
                    rootTappedNode = tempParent
                }
            }
            if let tappedARObjectNode = rootTappedNode as? ARObjectNode, DataManager.shared().userType == .Host{
                self.promptModelOptions(model: tappedARObjectNode)
            }
        }
    }


}
