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
    func didSelectObject(named name: String)
}

class MenuViewController: UIViewController{
    
    //This will be deleted (probably) it is to represent the height as that will probably change durring development
    static public let heightOfView: CGFloat = 200
    static public let heightOfExpandButton: CGFloat = 60
    private let widthOfImageView: CGFloat = 120
    private let spaceBetweenImageView: CGFloat = 30
    
    
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
    
    private var viewNames: [String] = ["Man", "Solar System", "Sun", "Mercury", "Venus", "Mars", "Earth", "Jupiter", "Saturn", "Uranus", "Pluto", "Bike", "Fighter", "Drone", "Ship"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        setUpScrollView()
        setUpExpandView()
        
        
    }
    
    private func updateView(){
        toggleMenu(with: expandState)
        updateMenuItems()
    }
    
    
    //MARK: - Expand Button
    
    private func setUpExpandView(){
        expandButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
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
        print("StartFrame: \(self.view.frame)")
        if state == .close{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.expandButton.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: MenuViewController.heightOfExpandButton)
                self?.scrollView.frame = CGRect(x: 0, y: MenuViewController.heightOfExpandButton, width: (self?.view.frame.width)!, height: MenuViewController.heightOfView - MenuViewController.heightOfExpandButton)
                print("Close Frame: \((self?.view.frame)!)")
            }) { [weak self] (completed)  in
                self?.expandImageView.image = #imageLiteral(resourceName: "expand")
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.expandLabel.alpha = 1
                })
            }
        }else{
            self.expandLabel.alpha = 0
//            self.view.backgroundColor = UIColor.white
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.expandButton.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: MenuViewController.heightOfExpandButton - 15)
                self?.scrollView.frame = CGRect(x: 0, y: MenuViewController.heightOfExpandButton - 15, width: (self?.view.frame.width)!, height: MenuViewController.heightOfView - (MenuViewController.heightOfExpandButton - 15))
                print("Open Frame: \((self?.view.frame)!)")
            }) { [weak self] (completed)  in
                self?.expandImageView.image = #imageLiteral(resourceName: "collapse")                
            }
        }
        self.expandState = state
        delegate.toggleMenu(for: state)
    }
    
    
    //MARK: - Scroll View
    
    private func setUpScrollView(){
        self.view.addSubview(scrollView)
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.isScrollEnabled = true
        
        
        print(self.view.frame)
        self.scrollView.frame = CGRect(x: 0, y: MenuViewController.heightOfExpandButton, width: self.view.frame.width, height: MenuViewController.heightOfView - MenuViewController.heightOfExpandButton)
        print(scrollView.frame)
        self.updateMenuItems()
    }
    
    private func updateMenuItems(){
        scrollView.subviews.forEach() { $0.removeFromSuperview() }
        var count: CGFloat = 0
        for i in viewNames{
            
            let heightOfLabel: CGFloat = 40
            
            let button = UIButton()
            button.setTitle("", for: .normal)
            button.tag = Int(count)
            button.frame = CGRect(x: ((widthOfImageView + spaceBetweenImageView) * count) + spaceBetweenImageView, y: ((MenuViewController.heightOfView - MenuViewController.heightOfExpandButton) - widthOfImageView) / 2, width: widthOfImageView, height: widthOfImageView)
//            button.backgroundColor = UIColor.blue
            
            let image = UIImage(named: i) ?? UIImage(named: "Logo")
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.frame = CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height - heightOfLabel)
            button.addSubview(imageView)
            button.addTarget(self, action: #selector(itemSelected(sender:)), for: .touchUpInside)
            
            scrollView.contentSize.width = ((spaceBetweenImageView + widthOfImageView) * (count + 1)) + spaceBetweenImageView
            scrollView.contentSize.height = button.frame.height
//            print("WIDTH: \(scrollView.contentSize.width)\t\t \(self.view.frame.width)")
            scrollView.addSubview(button)
            
            let frame = CGRect(x: 0, y: button.frame.height - (heightOfLabel), width: button.frame.width, height: heightOfLabel)
            let label = UILabel(frame: frame)
            label.text = i
            label.font = UIFont(name: "Avenir-Next", size: 25)
            label.textColor = UIColor.backgroundRed
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            button.addSubview(label)
            
            count += 1
        }
    }
    
    @objc private func itemSelected(sender: UIButton){
        self.toggleMenu(with: .close)
        delegate.didSelectObject(named: viewNames[sender.tag])
    }
    
    
}

extension UIColor{
    static let backgroundRed = UIColor(red: 0.835, green: 0.294, blue: 0.298, alpha: 1.00)
}
