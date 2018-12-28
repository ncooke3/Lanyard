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
}

class AddAccountVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var account: UITextField!
    
    var accountName:String = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1)
        
        self.setupHideKeyboardOnTap()
        
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

        self.view.addSubview(moveButton)
        moveButton.isUserInteractionEnabled = true

        moveButton.addTarget(self, action: #selector(moveButtonAction), for: .touchUpInside)


        ///TextEdit Setup
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        account = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        //border for dev
        //account.layer.borderColor = UIColor.orange.cgColor
        //account.layer.borderWidth = 1.0
        
        account.backgroundColor = .clear
        account.placeholder = "Enter Account Name..."
    
        //adds to view & creates delegate
        self.view.addSubview(account)
        self.account.delegate = self
        
        
    }
    
    @objc func popVC() {
        print("called popVC")
        self.navigationController?.popViewController(animated: false)
    }
    
    ///Add Button Action
    @objc func moveButtonAction() {
        print("Button Tapped")
        
        accountName = account.text!

        let userVC = AddUserVC()
        userVC.hero.isEnabled = true
        
        // enables Hero
        self.hero.isEnabled = true
        
        userVC.hero.isEnabled = true
        
        // this configures the built in animation
        userVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        
        userVC.key = accountName
        
        navigationController?.pushViewController(userVC, animated: true)
    }


    /// Dismisses keyboard when 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
