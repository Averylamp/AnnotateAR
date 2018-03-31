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
    func receivedObjectsUpdate(objects: [ARObject])
    func receivedNewObject(object: ARObject)
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
        displayLink.isPaused = true
    }
    
    var lastSelectedObjectSet = 0
    
    var connectivity = ConnectivityManager()
    
    var allConnectedDevices = [String]()
    
//    var userType: UserType = .Unknown
//    var state: State = .HostClientSelector
    var userType: UserType = .Host
    var state: State = .Demo
    var initialState:State = .Demo

    var alignmentSCNNodes = [SCNNode]()
    var alignmentPoints = [CGPoint]()
    
    var rootNode: SCNNode?
    var currentObjectMoving: SCNNode?
    
    var objects = [ARObject]()
    
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
   
    func sendAnimation(object: [String: Any]){
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendData(data: objectData)
    }
    
    func sendObject(object: ARObject){
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendData(data: objectData)
    }
    
    func updateObject(object: ARObject){
        if let root = rootNode{
            if let node = root.childNode(withName: object.id, recursively: true){
                print("Updating transform of object")
                node.transform = object.transform
            }
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
            
            for object in self.objects{
                self.sendObject(object: object)
                self.updateObject(object: object)
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
            if let newObject = object as? ARObject{
                print("AR Object update received")
                self.updateObject(object: newObject)
                self.delegate?.receivedNewObject(object: newObject)
            }
        }
    }
}
