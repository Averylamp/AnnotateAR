//
//  ARObjectNode.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import SceneKit

class ARObjectNode: SCNReferenceNode {
    
    var id: String
    var modelName: String
    var descriptionText: String

    
    init?(id: String = "",
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
        super.init(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
