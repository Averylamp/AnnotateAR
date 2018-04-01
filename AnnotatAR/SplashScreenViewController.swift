//
//  SplashScreenViewController.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import LTMorphingLabel

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var definitionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.animate(withDuration: 1.0) {
            self.mainLogo.center.y -= 100
        }
        self.delay(0.5) {
            UIView.animate(withDuration: 1.0, animations: {
                self.definitionLabel.alpha = 1.0
            })
        }
        
    }
    
}
