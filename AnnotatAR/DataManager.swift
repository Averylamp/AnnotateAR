//
//  DataManager.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit
import SceneKit

protocol DataManagerDelegate {
    func receivedObjectsUpdate(objects: [ARObjectNode])
    func receivedNewObject(object: ARObjectNode)
    func newDevicesConnected(devices: [String])
}

enum State {
    case HostClientSelector
    case FindCenter
    case Demo
}

enum UserType {
    case Unknown
    case Host
    case Client
}

class DataManager {

    var delegate : DataManagerDelegate?
    
    static var sharedInstance: DataManager = {
        let dataManager = DataManager()
        return dataManager
    }()
    class func shared() -> DataManager {
        return sharedInstance
    }
    
    var displayLink = CADisplayLink()
    
    init(){
        connectivity.delegate = self
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.preferredFramesPerSecond = 10
        displayLink.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        displayLink.isPaused = false
    }
    
    var lastSelectedObjectSet = 0
    
    var connectivity = ConnectivityManager()
    
    var allConnectedDevices = [String]()
    
    var userType: UserType = .Unknown
    var state: State = .HostClientSelector
    var initialState:State = .HostClientSelector
//    var userType: UserType = .Host
//    var state: State = .Demo
//    var initialState:State = .Demo

    
    var rootNode: SCNNode?
    var currentObjectMoving: ARObjectNode?
    
    @objc func update(){
        //       print("Run loop update \(CACurrentMediaTime())")
        if let node = self.currentObjectMoving, let root = rootNode{
            var data = [String: Any]()
            data["name"] = node.name!
            let newTransform = root.convertTransform(node.transform, from: node.parent)
            data["transform"] = newTransform.toFloatArray()
            print("Sending new Transform -\(newTransform)")
            sendAnimation(object: data)
        }
    }
    
    func addObject(object: ARObjectNode){
        self.currentObjectMoving = object
        self.sendObject(object: object)
    }
   
    func sendAnimation(object: [String: Any]){
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendData(data: objectData)
    }
    
    func sendObject(object: ARObjectNode){
        print("Sending object: \(object.id)")
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendData(data: objectData)
    }
    
    func updateObject(object: ARObjectNode){
        if let root = rootNode{
            if let node = root.childNode(withName: object.id, recursively: true){
                print("Updating transform of object")
                node.transform = object.transform
            }
        }
    }
    
    func lockCurrentMovingObject(){
        if let node = self.currentObjectMoving, let root = rootNode{
            node.transform = root.convertTransform(node.transform, from: node.parent)
            node.removeFromParentNode()
            root.addChildNode(node)
            sendObject(object: node)
            self.currentObjectMoving = nil
            self.displayLink.isPaused = true
        }
    }
    
    func nodeAnimation(nodeName: String, transform: SCNMatrix4){
        if let root = rootNode, let movingNode = root.childNode(withName: nodeName, recursively: false){
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = movingNode.transform
            animation.toValue = transform
            animation.duration = 6 / 60.0
            movingNode.addAnimation(animation, forKey: nil)
            movingNode.transform = transform
        }
    }
    
    
}

extension DataManager: ConnectivityManagerDelegate{
    
    func connectedDevicesChanged(manager: ConnectivityManager, connectedDevices: [String]) {
        print("--- Connected Devices Changed ---")
        var newDevices = [String]()
        for device in connectedDevices{
            if !self.allConnectedDevices.contains(device){
                newDevices.append(device)
            }
        }
        print("New Devices: \(newDevices)")
        if newDevices.count > 0{
            if let root = self.rootNode{
                for object in root.childNodes{
                    if let childNode = object as? ARObjectNode{
                        self.sendObject(object: childNode)
                        self.updateObject(object: childNode)
                    }
                }
            }
        }
        self.allConnectedDevices  = connectedDevices
        DispatchQueue.main.async {
            self.delegate?.newDevicesConnected(devices: newDevices)
        }
    }
    
    func dataReceived(manager: ConnectivityManager, data: Data) {
        print("Received Data" )
        DispatchQueue.main.async {
            let object = NSKeyedUnarchiver.unarchiveObject(with: data)
            if let newObject = object as? ARObjectNode{
                print("AR Object update received")
                self.updateObject(object: newObject)
                self.delegate?.receivedNewObject(object: newObject)
            }
            if let animationObject = object as? [String: Any], let nodeName = animationObject["name"] as? String, let transformValues = animationObject["transform"] as? [Float]{
                self.nodeAnimation(nodeName: nodeName, transform: SCNMatrix4.matrixFromFloatArray(transformValue: transformValues))
            }
        }
    }
}
