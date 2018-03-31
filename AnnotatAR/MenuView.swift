//
//  MenuView.swift
//  AnnotatAR
//
//  Created by alden lamp on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class MenuView: UIView{
    
    var size: CGFloat = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
