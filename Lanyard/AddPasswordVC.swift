//
//  AddPasswordVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

class AddPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var askUser: UILabel!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    
    var userName:String = ""
    var key = ""
    var pswrd:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupHideKeyboardOnTap()

        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.orange.cgColor]
        layer.startPoint = CGPoint(x: -0.50, y: -0.25)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        self.createAskUser()
        
        self.makeNextButton()
        
        self.setupPasswordTextEdit()
        
        self.devBorders(devBordersOn: false)
    }
    
    @objc func createAskUser() {
        askUser = UILabel()
        
        askUser.translatesAutoresizingMaskIntoConstraints = false
        
        askUser.text = "What's your password?"
        askUser.textAlignment = .center
        askUser.font = UIFont.boldSystemFont(ofSize: 30.0)
        askUser.textColor = .white
        
        askUser.sizeToFit()
        self.view.addSubview(askUser)
        
        askUser.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        askUser.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        askUser.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -225).isActive = true
    }
    
    @objc func makeNextButton() {
        let nextButton = UIButton(frame: CGRect(x: 310, y: 43, width: 60, height: 40))
        
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

        pswrd = password.text!

        accountsDict[key] = [userName, pswrd]
        accountsKeys.append(key)

        print(accountsDict)

        let mainVC = MainViewController()
        mainVC.hero.isEnabled = true

        self.hero.isEnabled = true
        mainVC.hero.isEnabled = true

        navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .right)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func setupPasswordTextEdit() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        password = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        password.backgroundColor = .clear
        password.placeholder = "Enter Password Name..."
        
        //adds to view & creates delegate
        self.view.addSubview(password)
        self.password.delegate = self
    }
    
}

