//
//  ARObjectNode.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import SceneKit

class ARObjectNode: SCNReferenceNode{
    
    var id: String
    var modelName: String
    var descriptionText: String
    
    
    init(id: String = "",
          modelName: String,
          transform: SCNMatrix4 = SCNMatrix4.init(),
          descriptionText: String = "" ) {
        if id == ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            self.id = dateFormatter.string(from: Date()) + "\(CACurrentMediaTime())"
        }else{
            self.id = id
        }
        self.modelName = modelName
        let url = Bundle.main.url(forResource: "art.scnassets/\(modelName)", withExtension: "scn")!
        self.descriptionText = descriptionText
        super.init(url: url)!
    }

    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let modelName = aDecoder.decodeObject(forKey: "modelName") as! String
        
        let transformValue = aDecoder.decodeObject(forKey: "transform") as! [Float]
        let transform = SCNMatrix4.matrixFromFloatArray(transformValue: transformValue)
        
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        
        self.init(
            id: id,
            modelName: modelName,
            transform: transform,
            descriptionText: descriptionText
        )
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encode(self.name, forKey: "name")
        
        aCoder.encode(self.transform.toFloatArray(), forKey: "transform")
        aCoder.encode(descriptionText, forKey: "descriptionText")
    }
    
    
}
