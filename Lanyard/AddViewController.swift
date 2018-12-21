//
//  AddViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

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

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterAccountName: UITextField!
    
    @IBOutlet weak var enterUsername: UITextField!
    
    @IBOutlet weak var enterPassword: UITextField!
    
    @IBAction func addAccount(sender: UIButton) {
        
        let accountName = enterAccountName.text!
        let username = enterUsername.text!
        let password = enterPassword.text!
        
        ///create a better way to handle cases where usr doesnt properly enter text
        if (accountName != "" && username != "" && password != "") {
            accountsDict[accountName] = [username, password]
            accountsKeys.append(accountName)
        }
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        
        self.enterAccountName.delegate = self
        self.enterUsername.delegate = self
        self.enterPassword.delegate = self
    }
    
    /// Tabs to next textboc or dismisses keyboard when 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == enterAccountName {
            textField.resignFirstResponder()
            enterUsername.becomeFirstResponder()
        } else if (textField == enterUsername) {
            textField.resignFirstResponder()
            enterPassword.becomeFirstResponder()
        } else if (textField == enterPassword) {
            self.view.endEditing(true)
            return false
        }
        
        return true

    }

}
