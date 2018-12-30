//
//  AddUserVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero


class AddUserVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    
    var key = ""
    
    var userName:String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupHideKeyboardOnTap()

        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ UIColor.lightGray.cgColor, UIColor.white.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        self.makeNextButton()
        self.setupUserTextEdit()
        
        self.devBorders(devBordersOn: false)
    }
    
    @objc func makeNextButton() {
        nextButton = UIButton(frame: CGRect(x: 310, y: 43, width: 60, height: 40))
        
        nextButton.backgroundColor = .clear
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        nextButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        ///make it highlight when selected
        
        nextButton.isUserInteractionEnabled = true
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        self.view.addSubview(nextButton)
    }
    
    @objc func nextButtonAction() {
        print("Button Tapped")
        
        userName = username.text!
        
        let pswrdVC = AddPasswordVC()
        
        // this enables Hero
        self.hero.isEnabled = true
        
        pswrdVC.hero.isEnabled = true
        
        navigationController?.hero.isEnabled = true
        
        pswrdVC.userName = userName
        pswrdVC.key = key
        
        navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
        
        navigationController?.pushViewController(pswrdVC, animated: true)
    }
    
    @objc func setupUserTextEdit() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        username = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        username.backgroundColor = .clear
        username.placeholder = "Enter Username..."
        
        //adds to view & creates delegate
        self.view.addSubview(username)
        self.username.delegate = self
    }
    
    
}
