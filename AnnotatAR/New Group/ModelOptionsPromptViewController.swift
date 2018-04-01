//
//  ModelOptionsPromptViewController.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

class ModelOptionsPromptViewController: UIViewController {

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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: ARObjectNode?
    
    func setModel(model:ARObjectNode){
        self.model = model
        self.titleLabel.text = "What would you like to do with the \(model.modelName) model?"
    }
    
    @IBAction func moveButtonClicked(_ sender: Any) {
        var userInfo = [String: Any]()
        userInfo["model"] = self.model
        NotificationCenter.default.post(name: moveModelOptionsNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(name: hideModelOptionsNotificationName, object: self)

    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        var userInfo = [String: Any]()
        userInfo["model"] = self.model
        NotificationCenter.default.post(name: deleteModelOptionsNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(name: hideModelOptionsNotificationName, object: self)
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        NotificationCenter.default.post(name: hideModelOptionsNotificationName, object: self)
    }
}
