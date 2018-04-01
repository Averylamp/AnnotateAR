//
//  ARObjectNode.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import SceneKit

let colors:[UIColor] = [
    UIColor.orange,
    UIColor(rgb: 0xff4d4d),
    UIColor(rgb: 0xffaf40),
    UIColor(rgb: 0x18dcff),
    UIColor(rgb: 0x32ff7e),
    UIColor(rgb: 0xcd84f1),
    UIColor(rgb: 0x7efff5),
    UIColor(rgb: 0xffcccc),
    UIColor(rgb: 0x7d5fff)
]

class ARObjectNode: SCNReferenceNode{
    static var annotationCount = 0
    static let maxAnnotations = 20
    var id: String
    var modelName: String
    var descriptionText: String
    var rootTransform: SCNMatrix4
    var colorID: Int
    
    init(id: String = "",
          modelName: String,
          rootTransform: SCNMatrix4 = SCNMatrix4.init(),
          descriptionText: String = "",
          colorID: Int = -1) {
        if id == ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            self.id = dateFormatter.string(from: Date()) + "\(CACurrentMediaTime())"
        }else{
            self.id = id
        }
        self.modelName = modelName
        var url : URL?
        if  modelName == "Circle" || modelName == "Text"{
            url = Bundle.main.url(forResource: "art.scnassets/Empty/Empty", withExtension: "scn")!
            // Yes this is horrible
        }else{
            url = Bundle.main.url(forResource: "art.scnassets/\(modelName)", withExtension: "scn")!
        }
        self.descriptionText = descriptionText
        self.rootTransform = rootTransform
        self.colorID = colorID
        
        super.init(url: url!)!
        self.name = self.id
    }

    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let modelName = aDecoder.decodeObject(forKey: "modelName") as! String
        
        let transformValue = aDecoder.decodeObject(forKey: "transform") as! [Float]
        let rootTransform = SCNMatrix4.matrixFromFloatArray(transformValue: transformValue)
        
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        let colorID = aDecoder.decodeInt32(forKey: "colorID")
        
        self.init(
            id: id,
            modelName: modelName,
            rootTransform: rootTransform,
            descriptionText: descriptionText,
            colorID: Int(colorID)
        )
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.colorID, forKey: "colorID")
        
        if (self.parent != DataManager.shared().rootNode), let root = DataManager.shared().rootNode{
            self.rootTransform = root.convertTransform(self.transform, from : root)
        }else{
            self.rootTransform = self.transform
        }
        print("Root transform : \(self.rootTransform)\nRegular transform : \(self.transform)")
        aCoder.encode(self.rootTransform.toFloatArray(), forKey: "transform")
        aCoder.encode(descriptionText, forKey: "descriptionText")
    }
    
    
    func setupNode(){
        self.load()
        switch self.modelName {
        case "Text":
            print("Text unimplemented still")
            let depth:CGFloat = 0.01
            let textGeometry = SCNText(string: self.descriptionText, extrusionDepth: depth)
            let font = UIFont(name: "Futura-Bold", size: 0.15)
            textGeometry.font = font
            textGeometry.alignmentMode = kCAAlignmentCenter
            if self.colorID != -1{
                textGeometry.firstMaterial?.diffuse.contents = colors[self.colorID % colors.count]
            }else{
                textGeometry.firstMaterial?.diffuse.contents = UIColor.orange
            }
            textGeometry.firstMaterial?.specular.contents = UIColor.white
            textGeometry.firstMaterial?.isDoubleSided = true
            textGeometry.chamferRadius = CGFloat(depth)
            
            let (minBound, maxBound) = textGeometry.boundingBox
            let textNode = SCNNode(geometry: textGeometry)
            textNode.position = SCNVector3.init(x: -0.1, y: -0.2, z: 0)
            textNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
            self.addChildNode(textNode)
            
        case "Circle":
            let torusGeometry = SCNTorus(ringRadius: 0.03, pipeRadius: 0.03 * 0.075)
            let torusMaterial = SCNMaterial()
            if self.colorID != -1{
                torusMaterial.diffuse.contents = colors[self.colorID % colors.count]
            }else{
                torusMaterial.diffuse.contents = UIColor.orange
            }
            torusGeometry.materials = [torusMaterial]
            let node = SCNNode(geometry: torusGeometry)
            node.eulerAngles.x = 90
            self.addChildNode(node)
        default:
            
            print("Normal object")
        }
    }
    
    
}
