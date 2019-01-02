//
//  AddViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

extension UIViewController {
    /// Dismisses open keyboards by tapping anywhere in vc
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())

        self.navigationController?.navigationBar
            .addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    /// Dismisses keyboard when 'return' is tapped
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    /// Toggles IBOutlet Borders for dev purposes
    @objc func devBorders(devBordersOn : Bool) {
        if (devBordersOn == true) {
            for item in view.subviews {
                item.layer.borderColor = UIColor.orange.cgColor
                item.layer.borderWidth = 1.0
            }
        }
    }
}

class AddAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var askUser: UILabel!

    @IBOutlet var account: UITextField!
    
    var accountName:String = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ blue.cgColor, UIColor.white.cgColor]
        //layer.startPoint = CGPoint(x: 0, y: 0)
        //layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        navigationItem.hidesBackButton = true
        
        let rightBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.setupHideKeyboardOnTap()
        
        self.createAskUser()
        self.setupAccountTextEdit()
        
        self.devBorders(devBordersOn: false)
    }
    
    @objc func createAskUser() {
        askUser = UILabel()
        
        askUser.translatesAutoresizingMaskIntoConstraints = false
        
        askUser.text = "What's the account?"
        askUser.textAlignment = .center
        askUser.font = UIFont.boldSystemFont(ofSize: 30.0)
        askUser.textColor = .white
        
        askUser.sizeToFit()
        self.view.addSubview(askUser)
        
        askUser.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        askUser.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        askUser.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -225).isActive = true

    }
    
    @objc func setupAccountTextEdit() {
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        account = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        account.backgroundColor = .clear
        account.placeholder = "Enter Account Name..."
        
        self.view.addSubview(account)
        self.account.delegate = self
    }
    
    ///Add Button Action
    @objc func nextButtonAction(_ sender: UIBarButtonItem!) {
        
        accountName = account.text!
        
        let userVC = AddUserVC()
        userVC.hero.isEnabled = true
        
        self.hero.isEnabled = true
        
        userVC.hero.isEnabled = true
        
        // this configures the built in animation
        userVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        
        userVC.key = accountName
        
        navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
        
        navigationController?.pushViewController(userVC, animated: true)
    }
}
