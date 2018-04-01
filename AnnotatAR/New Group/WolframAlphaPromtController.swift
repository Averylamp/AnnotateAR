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
        self.titleLabel.text = "What equation would you like to display to the group?"
        self.titleLabel.backgroundColor = UIColor.clear
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var equationTextField: UITextField!
    
    
    
    var equation = ""
    
//    func setModel(model:ARObjectNode){
//        self.model = model
    
//    }
    
    @IBAction func createButtonClicked(_ sender: Any) {
        
        if self.equationTextField.text == "" || self.equationTextField.text == nil{
            //TODO: - DO SOMETHING THAT SHOWS THE EQUATION DOES NOT WORK
            return
        }
        
        print(equationTextField.text!)
        var userInfo = [String: Any]()
        userInfo["equation"] = self.equationTextField.text!
        NotificationCenter.default.post(name: calculateEquationNotificationName, object: self, userInfo: userInfo)
        
    }
    
//    @IBAction func deleteButtonClicked(_ sender: Any) {
//        var userInfo = [String: Any]()
//        userInfo["model"] = self.model
//        NotificationCenter.default.post(name: deleteModelOptionsNotificationName, object: self, userInfo: userInfo)
//        NotificationCenter.default.post(name: hideModelOptionsNotificationName, object: self)
//    }
//
    
    @IBAction func cancelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: hideWolframAlphaNotificationName, object: self)
    }
}

