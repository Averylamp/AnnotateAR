//
//  ViewController+Notifications.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

let hideHostClientNotificationName = Notification.Name("HideHostClientNotification")
let hidePromptNotificationName = Notification.Name("HidePromptNotification")
let hideModelOptionsNotificationName = Notification.Name("HideModelOptionsNotification")
let moveModelOptionsNotificationName = Notification.Name("MoveModelOptionsNotification")
let deleteModelOptionsNotificationName = Notification.Name("DeleteModelOptionsNotification")
let hideWolframAlphaNotificationName = Notification.Name("HideWolframalphaNotification")
let calculateEquationNotificationName = Notification.Name("calculateWRAEquation")
let createTextNodeNotificationName = Notification.Name("CreateTextNodeNotification")
let hideTextPromptNotificationName = Notification.Name("HideTextPromptNotification")

extension ViewController{

    func initializeObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissHostClientVC), name: hideHostClientNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissPromptVC), name: hidePromptNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissModelOptionsVC), name: hideModelOptionsNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setupCurrentObjectForMoving(notification:)), name: moveModelOptionsNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.deleteCurrentObject(notification:)), name: deleteModelOptionsNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissWolframAlphaVC), name: hideWolframAlphaNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.calculateWolframalphaEquation(notification:)), name: calculateEquationNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.hideTextPromptVC), name: hideTextPromptNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.createTextNode(notification:)), name: createTextNodeNotificationName, object: nil)
        
    }

    @objc func dismissHostClientVC(){
        if self.view.subviews.contains(hostClientVC.view){
            hostClientVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.hostClientVC.view.center.y -= 30
                self.hostClientVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
        }
    }
    
    @objc func dismissPromptVC(){
        if self.view.subviews.contains(promptVC.view){
            promptVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.promptVC.view.center.y -= 30
                self.promptVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
        }
    }
    
    @objc func dismissModelOptionsVC(){
        if self.view.subviews.contains(modelOptionsVC.view){
            modelOptionsVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.modelOptionsVC.view.center.y -= 30
                self.modelOptionsVC.view.alpha = 0.0
            }) { (finished) in
                
            }
            self.unblockInteraction()
        }
    }
    
    @objc func dismissWolframAlphaVC(){
        if self.view.subviews.contains(WolframAlphaVC.view){
            WolframAlphaVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration) {
                self.WolframAlphaVC.view.center.y -= 30
                self.WolframAlphaVC.view.alpha = 0.0
            }
            self.unblockInteraction()
        }
    }
    
    @objc func setupCurrentObjectForMoving(notification: NSNotification){
        if let userInfo = notification.userInfo,
            let node = userInfo["model"] as? ARObjectNode,
            let pointOfView = self.sceneView.pointOfView{
            DataManager.shared().currentObjectMoving = node
            DataManager.shared().displayLink.isPaused = false
            let transform = pointOfView.convertTransform(node.transform, from: node.parent)
            node.transform = transform
            node.removeFromParentNode()
            pointOfView.addChildNode(node)
        }
    }
    
    @objc func deleteCurrentObject(notification: NSNotification){
        if let userInfo = notification.userInfo,
            let node = userInfo["model"] as? ARObjectNode{
            DataManager.shared().displayLink.isPaused = true
            DataManager.shared().deleteObject(object: node)
        }
    }
    
    @objc func calculateWolframalphaEquation(notification: NSNotification){
        if let userInfo = notification.userInfo, let equation = userInfo["equation"] as? String{
            var encodedString: String = equation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            print(encodedString)
            
            let requestURL = "http://annotatear.herokuapp.com/\(encodedString)"
            var request = URLRequest(url: URL(string: requestURL)!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, _) in
                
                
                print("\n")
                if let httpResponse = response as? HTTPURLResponse { print("response: \(httpResponse.statusCode)\n") }
                print("\n")
                if let httpResponse = response as? HTTPURLResponse { print("response: \(httpResponse)\n\n") }
                print("\n")
                
                let dataString = data?.base64EncodedString()
                
                print("dataString: \(String(describing: dataString))")
                

                
                
                //            let dataDecoded:NSData = NSData(base64EncodedString: data, options: NSData.Base64DecodingOptions(rawValue: 0))!

//                let dataDecoded : Data? = Data(base64Encoded: data!, options: .ignoreUnknownCharacters)
//                let decodedimage: UIImage = UIImage(data: dataDecoded!)!
//
//                let imageView = UIImageView()
//                imageView.image = decodedimage
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                self?.view.addSubview(imageView)
//                imageView.centerXAnchor.constraint(equalTo: (self?.view.centerXAnchor)!, constant: 0).isActive = true
//                imageView.centerYAnchor.constraint(equalTo: (self?.view.centerYAnchor)!, constant: 0).isActive = true
//                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
            }).resume()
        }
    }
    
    @objc func hideTextPromptVC(){
        if self.view.subviews.contains(textPromptVC.view){
            textPromptVC.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration) {
                self.textPromptVC.view.center.y -= 30
                self.textPromptVC.view.alpha = 0.0
            }
            self.unblockInteraction()
        }
    }
    
    @objc func createTextNode(notification: NSNotification){
        if let userInfo = notification.userInfo,
            let text = userInfo["text"] as? String{
            let node = ARObjectNode(modelName: "Text", descriptionText: text, colorID: colorIndex % colors.count)
            node.setupNode()
            self.addARObjectNode(node: node)
        }
        
    }
    
}
