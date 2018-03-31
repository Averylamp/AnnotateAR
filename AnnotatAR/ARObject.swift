//
//  ARObject.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import Foundation
import SceneKit

class ARObject: NSObject, NSCoding {
    
    var id: String
    var modelName: String
    var name:String
    var animation: [String]
    var transform: SCNMatrix4
    var descriptionText: String
    var mass: Double
    var restitution:Double

    init(id: String = "",
         name: String,
         modelName: String,
         animation: [String],
         transform: SCNMatrix4, descriptionText: String, mass: Double, restitution:Double) {
        if id == ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            self.id = dateFormatter.string(from: Date()) + "\(CACurrentMediaTime())"
        }else{
            self.id = id
        }
        self.modelName = modelName
        self.name = name
        self.animation = animation
        self.transform = transform
        self.descriptionText = descriptionText
        self.mass = mass
        self.restitution = restitution
    }
    
    // MARK: NSCoding
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let modelName = aDecoder.decodeObject(forKey: "modelName") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let animation = aDecoder.decodeObject(forKey: "animation") as! [String]
        let transformValue = aDecoder.decodeObject(forKey: "transform") as! [Float]
        let transform = SCNMatrix4.matrixFromFloatArray(transformValue: transformValue)
        
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        let mass = aDecoder.decodeObject(forKey: "mass") as! NSNumber
        let restitution = aDecoder.decodeObject(forKey: "restitution") as! NSNumber
        self.init(
            id: id,
            name: name,
            modelName: modelName,
            animation: animation,
            transform: transform,
            descriptionText: descriptionText,
            mass: mass.doubleValue,
            restitution:restitution.doubleValue
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.animation, forKey: "animation")
        
        aCoder.encode(self.transform.toFloatArray(), forKey: "transform")
        aCoder.encode(descriptionText, forKey: "descriptionText")
        
        aCoder.encode(NSNumber.init(value: mass), forKey: "mass")
        aCoder.encode(NSNumber.init(value: restitution), forKey: "restitution")
    }
}
