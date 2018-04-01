//
//  TextPromptViewController.swift
//  AnnotatAR
//
//  Created by Avery on 4/1/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

class TextPromptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        textField.delegate = self
    }

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func createClicked(_ sender: Any) {
        if self.textField.text == ""{
            self.cancelClicked(sender)
            return
        }
        var userInfo = [String:String]()
        userInfo["text"] = self.textField.text
        NotificationCenter.default.post(name: createTextNodeNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(name: hideTextPromptNotificationName, object: self)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: hideTextPromptNotificationName, object: self)
    }
    
}

extension TextPromptViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
