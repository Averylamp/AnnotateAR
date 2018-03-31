//
//  PromptViewController.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

class PromptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
    }
    
    @IBOutlet weak var promptMainText: UILabel!
    @IBOutlet weak var promptButtonLabel: UIButton!
    
    func setupPrompt(mainText:String, confirmationText:String){
        self.promptMainText.text = mainText
        self.promptButtonLabel.setTitle(confirmationText, for: .normal)
    }
    
    @IBAction func promptConfirmationClicked(_ sender: Any) {
        NotificationCenter.default.post(name: hidePromptNotificationName, object: self)
    }
    

}
