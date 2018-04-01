//
//  WolframAlphaPromtController.swift
//  AnnotatAR
//
//  Created by alden lamp on 4/1/18.
//  Copyright © 2018 Avery. All rights reserved.
//
import UIKit

class WolframAlphaPromptController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        equationTextField.delegate = self
    }
    
    @IBOutlet var equationTextField: UITextField!
    
    var equation = ""
    
    @IBAction func createButtonClicked(_ sender: Any) {
        
        if self.equationTextField.text == "" || self.equationTextField.text == nil{
            //TODO: - DO SOMETHING THAT SHOWS THE EQUATION DOES NOT WORK
            cancelClicked(sender)
            return
        }
        
        print(equationTextField.text!)
        var userInfo = [String: Any]()
        userInfo["equation"] = self.equationTextField.text!
        NotificationCenter.default.post(name: calculateEquationNotificationName, object: self, userInfo: userInfo)
        
    }
    

    @IBAction func cancelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: hideWolframAlphaNotificationName, object: self)
    }
}

extension WolframAlphaPromptController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

