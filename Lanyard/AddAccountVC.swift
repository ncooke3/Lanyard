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

    @IBOutlet var account: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    
    var accountName:String = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ blue.cgColor, UIColor.white.cgColor]
        //layer.startPoint = CGPoint(x: 0, y: 0)
        //layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        navigationController?.isNavigationBarHidden = true
        
        self.setupHideKeyboardOnTap()
        
        self.makeNextButton()
        
        self.setupAccountTextEdit()
        
        self.devBorders(devBordersOn: false)
        
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
    
    @objc func makeNextButton() {
        nextButton = UIButton(frame: CGRect(x: 310, y: 43, width: 60, height: 40))
        
        nextButton.backgroundColor = .clear
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        nextButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        ///make it highlight when selected
        
        self.view.addSubview(nextButton)
        nextButton.isUserInteractionEnabled = true
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    ///Add Button Action
    @objc func nextButtonAction() {
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
        
        navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
        
        navigationController?.pushViewController(userVC, animated: true)
    }
}
