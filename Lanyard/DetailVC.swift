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
        
        ///Account Name Setup
        let accountName = UILabel(frame: CGRect(x: 20, y: 80, width: 100, height: 20))
        
        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0
        
        accountName.text = key
        accountName.font = UIFont.boldSystemFont(ofSize: 17.0)
        accountName.sizeToFit()
        
        self.view.addSubview(accountName)
        
        ///Username Setup
        let username = UILabel(frame: CGRect(x: 20, y: 200, width: 100, height: 20))

        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0

        username.text = accountsDict[key]?[0]
        username.font = UIFont.boldSystemFont(ofSize: 17.0)
        username.sizeToFit()

        self.view.addSubview(username)

        ///Password
        let password = UILabel(frame: CGRect(x: 20, y: 300, width: 100, height: 20))

        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0

        password.text = accountsDict[key]?[1]
        password.font = UIFont.boldSystemFont(ofSize: 17.0)
        password.sizeToFit()

        self.view.addSubview(password)

        ///Add Button Setup
        let moveButton = UIButton(frame: CGRect(x: 310, y: 43, width: 60, height: 40))
        
        //border for dev
        //moveButton.layer.borderColor = UIColor.orange.cgColor
        //moveButton.layer.borderWidth = 1.0
        
        moveButton.backgroundColor = .clear
        moveButton.setTitle("Done", for: .normal)
        moveButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        moveButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        ///make it highlight when selected
        
        self.view.addSubview(moveButton)
        moveButton.isUserInteractionEnabled = true
        
        moveButton.addTarget(self, action: #selector(moveButtonAction), for: .touchUpInside)
    }

    ///Add Button Action
    @objc func moveButtonAction() {
        
        let mainVC = MainViewController()
        mainVC.hero.isEnabled = true
        
        self.hero.isEnabled = true
        mainVC.hero.isEnabled = true
        
        mainVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .right), dismissing: .slide(direction: .down))
        
        
        navigationController?.popToRootViewController(animated: true)
    }

}
