//
//  UIViewControllerExtension.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 7/20/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
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
    
    /// Dismisses keyboard when 'return' is tapped
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.accountField.textColor = UIColor.black
        return false
    }
    
    /// Toggles Borders for dev purposes
    @objc func devBorders(devBordersOn : Bool) {
        if (devBordersOn == true) {
            for item in view.subviews {
                item.layer.borderColor = UIColor.orange.cgColor
                item.layer.borderWidth = 1.0
            }
        }
    }
}
