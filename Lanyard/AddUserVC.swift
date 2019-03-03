//
//  AddUserVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 35, height: 30))
        
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}


class AddUserVC: UIViewController, UITextFieldDelegate {
    var askUser: UILabel!
    
    var username: UITextField!
    
    var key = ""
    
    var userName:String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupHideKeyboardOnTap()

        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ blue.cgColor, UIColor.white.cgColor]
        //layer.startPoint = CGPoint(x: 0, y: 0)
        //layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        navigationItem.hidesBackButton = true
        
        let rightBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.createAskUser()
        self.setupUserTextEdit()
        
        self.devBorders(devBordersOn: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func createAskUser() {
        askUser = UILabel()
        
        askUser.translatesAutoresizingMaskIntoConstraints = false
        
        askUser.text = "What's your username?"
        askUser.textAlignment = .center
        askUser.font = UIFont.boldSystemFont(ofSize: 30.0)
        askUser.textColor = UIColor.gray
        
        askUser.backgroundColor = .white
        askUser.layer.backgroundColor = UIColor.white.cgColor
        askUser.layer.cornerRadius = 7.0
        askUser.layer.masksToBounds = true
        
        self.view.addSubview(askUser)
        
        askUser.widthAnchor.constraint(equalToConstant: 350).isActive = true
        askUser.heightAnchor.constraint(equalToConstant: 100).isActive = true
        askUser.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        askUser.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -225).isActive = true
    }
    
    
    @objc func nextButtonAction(_ sender: UIBarButtonItem) {
        
        userName = username.text!
        
        let pswrdVC = AddPasswordVC()
        pswrdVC.key = key
        pswrdVC.username = userName

        navigationController?.pushViewController(pswrdVC, animated: true)
    }
    
    @objc func setupUserTextEdit() {
        
        username = UITextField()
        
        username.translatesAutoresizingMaskIntoConstraints = false
    
        username.tintColor = UIColor.lightGray
        username.setIcon(#imageLiteral(resourceName: "icon-user"))
        
        username.backgroundColor = .white
        username.placeholder = "Username"
        username.layer.cornerRadius = 7.0
        
        self.view.addSubview(username)
        self.username.delegate = self
        
        username.widthAnchor.constraint(equalToConstant: 325).isActive = true
        username.heightAnchor.constraint(equalToConstant: 40).isActive = true
        username.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        username.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
