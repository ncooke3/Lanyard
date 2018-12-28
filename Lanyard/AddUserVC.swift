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
    
    var key = ""
    
    var userName:String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .green
        
        print("Username")
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
        username = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        //border for dev
        //account.layer.borderColor = UIColor.orange.cgColor
        //account.layer.borderWidth = 1.0
        
        username.backgroundColor = .clear
        username.placeholder = "Enter Username..."
        
        //adds to view & creates delegate
        self.view.addSubview(username)
        self.username.delegate = self
        
        
    }
    
    @objc func popVC() {
        print("called popVC")
        self.navigationController?.popViewController(animated: false)
    }
    
    
    ///Add Button Action
    @objc func moveButtonAction() {
        print("Button Tapped")
        
        userName = username.text!
        
        let pswrdVC = AddPasswordVC()
        
        // this enables Hero
        self.hero.isEnabled = true
        
        pswrdVC.hero.isEnabled = true
        
        // this configures the built in animation
        pswrdVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        
        pswrdVC.userName = userName
        pswrdVC.key = key
        
        navigationController?.pushViewController(pswrdVC, animated: true)
    }
    
    
    /// Dismisses keyboard when 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
