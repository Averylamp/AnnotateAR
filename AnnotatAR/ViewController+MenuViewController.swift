//
//  ViewController+MenuViewController.swift
//  AnnotatAR
//
//  Created by alden lamp on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: MenuViewControllerDelegate{
    func toggleMenu(for state: menuState) {
        
        print("the menu will be toggled for: \(state == .close ? "Close" : "Open")")
        if state == .close{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                
                self?.menuVC.view.frame = CGRect(x: CGFloat(0), y: (self?.view.frame.height)! - MenuViewController.heightOfExpandButton, width: (self?.view.frame.height)!, height: MenuViewController.heightOfView)
                
            })
        }else{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.menuVC.view.frame = CGRect(x: CGFloat(0), y: (self?.view.frame.height)! - MenuViewController.heightOfView, width: (self?.view.frame.height)!, height: MenuViewController.heightOfView)
            })
        }
    }
    
    func didSelectObject(named name: String) {
        self.addARObjectNode(name: name)
    }
}


