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
    
    func addTestRoot(){
        
        let pointNode = SCNNode()
        let pointGeometry = SCNSphere(radius: 0.007)
        let orangeMaterial = SCNMaterial()
        orangeMaterial.diffuse.contents = UIColor.orange
        pointGeometry.materials = [orangeMaterial]
        pointNode.geometry = pointGeometry
        pointNode.position = SCNVector3.init(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(pointNode)
        DataManager.shared().rootNode = pointNode
        
    }
    
    func addTestObject(name:String){
        let node = ARObjectNode(modelName: name)
        node.load()
        node.position = SCNVector3Make(0, 0, -1)
        DataManager.shared().currentObjectMoving = node
        self.sceneView.pointOfView?.addChildNode(node)
        
    }
    
    func demoScreenTapped(){
        print("Lock node called")
        if let node = DataManager.shared().currentObjectMoving, let root = DataManager.shared().rootNode {
            node.transform = root.convertTransform(node.transform, from: node.parent)
            node.removeFromParentNode()
            root.addChildNode(node)

        }
        
    }


}
