//
//  ViewController+Gestures.swift
//  AnnotatAR
//
//  Created by Avery on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import UIKit

extension ViewController: UIGestureRecognizerDelegate{

    @objc func handleSingleTap(gestureRecognizer: UITapGestureRecognizer){
        print("Screen tapped")
        switch DataManager.shared().state {
        case .Demo:
            demoScreenTapped(gestureRecognizer: gestureRecognizer)
        case .HostClientSelector:
            print("Unhandled tap")
        case .FindCenter:
            print("Unhandled tap")
            DataManager.shared().state = .Demo
            nextState()
        default:
            print("Unhandled tap")
        }
    }
    
}
