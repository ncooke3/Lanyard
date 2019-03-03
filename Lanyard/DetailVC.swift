//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var accountDisplay: UILabel!
    
    var usernameDisplay: UILabel!
    
    var passwordDisplay: UILabel!
    
    let account: Account
    
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Make the nav bar go small upon trans to this view controller
    //make the nav bar transparent, same as the UI Image maybe?
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [blue.cgColor, UIColor.white.cgColor]
        view.layer.addSublayer(layer)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)
        
        self.displayAccount()
        self.displayUsername()
        self.displayPassword()
    }
    
    @objc func displayAccount() {
        accountDisplay = UILabel()
        
    accountDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        accountDisplay.text = self.account.service
        accountDisplay.textAlignment = .center
        accountDisplay.font = UIFont.boldSystemFont(ofSize: 30.0)
        accountDisplay.textColor = .white
        
        accountDisplay.sizeToFit()
        self.view.addSubview(accountDisplay)
        
        accountDisplay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        accountDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -225).isActive = true
    }

    @objc func displayUsername() {
        usernameDisplay = UILabel()
        
        usernameDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        usernameDisplay.text = self.account.username
        usernameDisplay.textAlignment = .center
        usernameDisplay.font = UIFont.boldSystemFont(ofSize: 30.0)
        usernameDisplay.textColor = .white
        
        usernameDisplay.sizeToFit()
        self.view.addSubview(usernameDisplay)
        
        usernameDisplay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func displayPassword() {
        passwordDisplay = UILabel()
        
        passwordDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        passwordDisplay.text = self.account.password
        passwordDisplay.textAlignment = .center
        passwordDisplay.font = UIFont.boldSystemFont(ofSize: 30.0)
        passwordDisplay.textColor = .white
        
        passwordDisplay.sizeToFit()
        self.view.addSubview(passwordDisplay)
        
        passwordDisplay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        passwordDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 225).isActive = true
    }
    
    @objc private func toggleNavButtons() {
        
        navigationItem.rightBarButtonItem?.title = navigationItem.rightBarButtonItem?.title == "Edit" ? "Done" : "Edit"
        if navigationItem.rightBarButtonItem?.title == "Done" {
            navigationItem.setHidesBackButton(true, animated:true)
        } else {
            navigationItem.setHidesBackButton(false, animated:true)
        }
    }

}
