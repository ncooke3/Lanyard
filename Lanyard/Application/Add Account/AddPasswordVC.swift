//
//  AddPasswordVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddPasswordVC: UIViewController, UITextFieldDelegate {
    
    var askUser: UILabel!
    
    var password: UITextField!
    
    var key = ""
    
    var username: String = ""
  
    var pswrd: String = ""
    
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
        
        let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.createAskUser()
        
        self.setupPasswordTextEdit()
        
        self.devBorders(devBordersOn: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func createAskUser() {
        askUser = UILabel()
        
        askUser.translatesAutoresizingMaskIntoConstraints = false
        
        askUser.text = "What's your pasword?"
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
        pswrd = password.text!
        let account = Account(service: key, username: username, password: pswrd)
        Defaults.accounts.append(account)
        addCompany(companyName: account.service, completion: { (companyName, url) in
            let defaultURL = URL(string: "placeholder")
            let logoURL = url ?? defaultURL!
            CompanyDefaults.companies[companyName] = Company(name: companyName, initials: nil, logoURL: logoURL, brandColor: nil)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func addCompany(companyName: String, completion: @escaping (String, URL?) -> Void) {
        let company = companyName.replacingOccurrences(of: " ", with: "")
        Alamofire.request("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(company)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let stringURL = json[0]["logo"].string ?? ""
                let url = URL(string: stringURL)
                completion(companyName, url)
            case .failure(let error):
                print(error)
                completion(companyName, nil)
            }
        }
    }
    
    @objc func setupPasswordTextEdit() {
        password = UITextField()
        
        password.translatesAutoresizingMaskIntoConstraints = false
        
        password.tintColor = UIColor.lightGray
        password.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
        password.backgroundColor = .white
        password.placeholder = "Password"
        password.layer.cornerRadius = 7.0
        
        self.view.addSubview(password)
        self.password.delegate = self
        
        password.widthAnchor.constraint(equalToConstant: 325).isActive = true
        password.heightAnchor.constraint(equalToConstant: 40).isActive = true
        password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

