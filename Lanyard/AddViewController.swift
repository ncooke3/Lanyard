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
    
    @IBOutlet weak var enterAccountInfo: UITextField!
    
       
    @IBAction func addAccount(sender: UIButton) {
        
        let accountName = enterAccountName.text!
        let accountInfo1 = enterAccountInfo.text!
        
        ///create a better way to handle cases where usr doesnt properly enter text
        if (accountName != "" && accountInfo1 != "") {
            accounts.append(accountName)
            accountInfo.append(accountInfo1)
        }
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        
        self.enterAccountName.delegate = self
        self.enterAccountInfo.delegate = self
    }
    
    /// Dismisses keyboard if 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

}
