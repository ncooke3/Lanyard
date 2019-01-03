//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet var accountDisplay: UILabel!
    
    @IBOutlet var usernameDisplay: UILabel!
    
    @IBOutlet var passwordDisplay: UILabel!

    var key : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1)
        
        navigationItem.backBarButtonItem?.isEnabled = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)
        
        self.displayAccount()
        self.displayUsername()
        self.displayPassword()
    }
    
    @objc func displayAccount() {
        accountDisplay = UILabel()
        
        accountDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        accountDisplay.text = key
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
        
        usernameDisplay.text = Defaults.accountsDict[key]?[0]
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
        
        passwordDisplay.text = Defaults.accountsDict[key]?[1]
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
    
//    /// Allows for system Back button with custom function
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("vwd called")
//
//        navigationItem.hidesBackButton = true
//
//        if self.isMovingFromParent {
//            print("hits")
//            self.moveButtonAction()
//        }
//    }
//
//    @objc func moveButtonAction() {
//        print("move called")
//        
//        //navigationController?.navigationBar.isHidden = true
//
//        let mainVC = MainViewController()
//        mainVC.hero.isEnabled = true
//
//        self.hero.isEnabled = true
//        mainVC.hero.isEnabled = true
//        
//        //self.navigationController?.setNavigationBarHidden(true, animated: false)
//
//        navigationController?.hero.navigationAnimationType = .zoomOut
//        
//        navigationController?.popViewController(animated: true)
//
//        //navigationController?.popToRootViewController(animated: true)
//    }

}
