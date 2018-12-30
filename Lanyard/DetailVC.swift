//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var key : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1)
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        ///Account Name Setup
        let accountName = UILabel(frame: CGRect(x: displayWidth / 2, y: displayHeight / 3, width: 100, height: 20))
        
        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0
        
        accountName.text = key
        accountName.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        //accountName.sizeToFit()
        
        self.view.addSubview(accountName)
        
        ///Username Setup
        let username = UILabel(frame: CGRect(x: displayWidth / 2, y: displayHeight / 2, width: 100, height: 20))

        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0

        username.text = accountsDict[key]?[0]
        username.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        username.center.x = self.view.center.x
        
        //username.sizeToFit()

        self.view.addSubview(username)

        ///Password
        let password = UILabel(frame: CGRect(x: displayWidth / 2, y: 2 * (displayHeight / 3), width: 100, height: 20))

        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0

        password.text = accountsDict[key]?[1]
        password.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        password.center.x = self.view.center.x
        
        password.sizeToFit()

        self.view.addSubview(password)
    }
    
    
    /// Allows for system Back button with custom function
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            print("hits")
            self.moveButtonAction()
        }
    }

    ///Add Button Action
    @objc func moveButtonAction() {

        let mainVC = MainViewController()
        mainVC.hero.isEnabled = true

        self.hero.isEnabled = true
        mainVC.hero.isEnabled = true

        navigationController?.hero.navigationAnimationType = .zoomOut

        navigationController?.popToRootViewController(animated: true)
    }

}
