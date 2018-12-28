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
    
    @IBOutlet var password: UITextField!
    
    var userName:String = ""
    var key = ""
    
    var pswrd:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.setupHideKeyboardOnTap()

        view.backgroundColor = .orange
        
        print("Password")
        print(key)
        print(userName)
        
        
        ///Add Button Setup
        let moveButton = UIButton(frame: CGRect(x: 310, y: 43, width: 60, height: 40))
        
        //border for dev
        //moveButton.layer.borderColor = UIColor.orange.cgColor
        //moveButton.layer.borderWidth = 1.0
        
        moveButton.backgroundColor = .clear
        moveButton.setTitle("Next", for: .normal)
        moveButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        moveButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        ///make it highlight when selected

        moveButton.isUserInteractionEnabled = true
        
        moveButton.addTarget(self, action: #selector(moveButtonAction), for: .touchUpInside)
        
        self.view.addSubview(moveButton)
        
        
        ///TextEdit Setup
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        password = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        
        password.backgroundColor = .clear
        password.placeholder = "Enter Password Name..."
        
        //adds to view & creates delegate
        self.view.addSubview(password)
        self.password.delegate = self
    }
    
    @objc func popVC() {
        print("called popVC")
        self.navigationController?.popViewController(animated: false)
    }
    
    
    ///Add Button Action
    @objc func moveButtonAction() {
        print("Button Tapped")

        pswrd = password.text!

        accountsDict[key] = [userName, pswrd]
        accountsKeys.append(key)
        print("Added!")
        print(accountsDict)

        let mainVC = MainViewController()
        mainVC.hero.isEnabled = true

        self.hero.isEnabled = true
        mainVC.hero.isEnabled = true

        mainVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .right), dismissing: .slide(direction: .down))

        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Dismisses keyboard when 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

