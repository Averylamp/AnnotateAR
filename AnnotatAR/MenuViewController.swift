//
//  MenuViewController.swift
//  AnnotatAR
//
//  Created by alden lamp on 3/31/18.
//  Copyright © 2018 Avery. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

enum menuState{
    case close
    case open
}

protocol MenuViewControllerDelegate: class {
    func toggleMenu(for state: menuState)
}

class MenuViewController: UIViewController{
    
    //This will be deleted (probably) it is to represent the height as that will probably change durring development
    static public let heightOfView: CGFloat = 200
    static public let heightOfExpandButton: CGFloat = 55
    
    //horizontal scroll view to preview the items
    private let scrollView = UIScrollView()
    
    private let expandButton = UIButton()
    private let expandLabel = UILabel()
    private let expandImageView = UIImageView()
    
    public weak var delegate: MenuViewControllerDelegate!
    
    //Setting this to false prevents the expansion of menu
    public var allowsExpand = true
    
    //tells if the current menu is open or closed
    private var expandState: menuState = .close
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        
        setUpExpandView()
        
    }
    
    private func updateView(){
        toggleMenu(with: expandState)
    }
    
    private func setUpExpandView(){
        expandButton.backgroundColor = UIColor.white
        expandButton.setTitle("", for: .normal)
        expandButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: MenuViewController.heightOfExpandButton)
        self.view.addSubview(expandButton)
        
        expandImageView.image = #imageLiteral(resourceName: "expand")
        expandImageView.frame = CGRect(x: self.view.frame.midX - 15, y: 5, width: 30, height: 30)
        self.expandButton.addSubview(expandImageView)
        
        self.expandButton.addSubview(expandLabel)
        
        expandLabel.text = "select a different model"
        expandLabel.textColor = UIColor.backgroundRed
        expandLabel.font = UIFont(name: "Avenir-Next", size: 20)
        expandLabel.frame = CGRect(x: self.view.frame.midX - 150, y: 35, width: 300, height: 15)
        expandLabel.textAlignment = .center
        expandLabel.adjustsFontSizeToFitWidth = true
        
        expandButton.backgroundColor = UIColor.white
        expandButton.layer.borderColor = UIColor.white.cgColor
        expandButton.layer.borderWidth = 0
        expandButton.layer.shadowColor = UIColor.lightGray.cgColor
        expandButton.layer.shadowOffset = CGSize(width: 1, height: -2.5)
        expandButton.layer.shadowRadius = 1
        expandButton.layer.shadowOpacity = 0.4
        
        expandButton.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
    }
    
    @objc private func didTouchButton(){
        toggleMenu(with: expandState == .close ? .open : .close)
    }
    
    //internal view changes and updating views (also calls delegate)
    func toggleMenu(with state: menuState){
        
        //Prevents menu from opening when it's not supposed to 
//        if state == self.expandState || !allowsExpand { return }
        if !allowsExpand { return }

        if state == .close{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.expandButton.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: MenuViewController.heightOfExpandButton)
                self?.expandLabel.alpha = 1
            }) { [weak self] (completed)  in
                self?.expandImageView.image = #imageLiteral(resourceName: "expand")
            }
        }else{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.expandButton.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: 40)
                self?.expandLabel.alpha = 0
            }) { [weak self] (completed)  in
                self?.expandImageView.image = #imageLiteral(resourceName: "collapse")                
            }
        }
        self.expandState = state
        delegate.toggleMenu(for: state)
    }
    
}

extension UIColor{
    static let backgroundRed = UIColor(red: 0.835, green: 0.294, blue: 0.298, alpha: 1.00)
}
