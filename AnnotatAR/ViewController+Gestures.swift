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
    
    
    
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        if menuVC.allowsExpand{
            switch recognizer.state {
            case .began:
                print("Began sliding VC")
            case .changed:
                let translation = recognizer.translation(in: view).y
                if translation + menuVC.view.frame.maxY < menuVC.view.frame.height + self.view.frame.height && translation + menuVC.view.frame.maxY > self.view.frame.height{
                    menuVC.view?.center.y = menuVC.view!.center.y + translation
                }
                recognizer.setTranslation(CGPoint.zero, in: view)
            case .ended:
                print("ENDED")
                if menuVC.view.frame.maxY < self.view.frame.height + menuVC.view.frame.height/2 - MenuViewController.heightOfExpandButton/2{
                    if recognizer.velocity(in: view).y > 100{
                        menuVC.toggleMenu(with: .close)
                    }else{
                        menuVC.toggleMenu(with: .open)
                    }
                }else{
                    if recognizer.velocity(in: view).y < -100{
                        menuVC.toggleMenu(with: .open)
                    }else{
                        menuVC.toggleMenu(with: .close)
                    }
//                    menuVC.toggleMenu(with: .close)
                }
            default:
                break
            }
        }
    }
    
}
