//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import UIImageColors
import SwiftyJSON

class DetailVC: UIViewController, UITextFieldDelegate {
    
    var accountDisplay: UILabel!
    
    private var request: Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    // implementing new editable labels
    
    let usernameField = UITextField()
    
    let passwordField = UITextField()
    
    
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//        self.getLogoURL(service: self.account.service, completion: { string in
//            if let string = string {
//                //use the return value
//                print(string)
//
//                self.getLogo(url: string)
//
//            } else {
//                //handle nil response
//
//                print("Failed bro")
//            }
//        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)
        

        
        //self.getLogoURL(service: self.account.service)
        
        
        
        self.getLogoURL(service: self.account.service, completion: { string in
            if let string = string {
                //use the return value
                print(string)
                
                self.getLogo(url: string)
                
            } else {
                //handle nil response
                
                print("Failed bro")
            }
        })
        
        
        
        
        self.displayAccount()

        self.setupUserTextEdit()
        self.setupPasswordTextEdit()
    }

    func getLogoURL(service: String, completion: @escaping (String?)-> Void) {
        var returnValue: (String?)
        
        print("Service" + service)
        
        let comp = service.replacingOccurrences(of: " ", with: "")
        
        print(comp)
        
        request = Alamofire.request("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(comp)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                returnValue = json[0]["logo"].string!
                completion(returnValue)
                //print(logoURL)
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getLogo(url: String){
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let logoImage = response.result.value {
                print("image downloaded: \(logoImage)")
                
                self.updateBackground(image: logoImage)
                
                self.addLogoToView(image: logoImage)
            }
        }
    }
    
    func addLogoToView(image: UIImage) {
        let resizedImage = image.af_imageAspectScaled(toFit: CGSize(width: 115, height: 115))
        
        let logo = UIImageView(image: resizedImage)
        
        //logo.image?.af_imageAspectScaled(toFit: CGSize(width: 200, height: 200))
        
        logo.layer.cornerRadius = logo.frame.size.width / 2;
        logo.layer.borderWidth = 3.0
        logo.layer.borderColor = UIColor.white.cgColor
        logo.clipsToBounds = true
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 6)).isActive = true
    }
    
    func updateBackground(image: UIImage) {
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        let colors = image.getColors()
        
        layer.backgroundColor = colors?.background.cgColor
        navigationController?.navigationBar.barTintColor = colors?.background
        view.layer.addSublayer(layer)
        
    }
    
    func setupUserTextEdit() {
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        usernameField.tintColor = UIColor.lightGray
        usernameField.setIcon(#imageLiteral(resourceName: "icon-user"))
        
        usernameField.backgroundColor = .white
        usernameField.text = self.account.username
        usernameField.placeholder = "Username"
        usernameField.textColor = UIColor.gray
        usernameField.layer.cornerRadius = 7.0
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        usernameField.layer.borderWidth = 1.0
        
        usernameField.isEnabled = false
        
        self.view.addSubview(usernameField)
        self.usernameField.delegate = self
        
        usernameField.widthAnchor.constraint(equalToConstant: 325).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupPasswordTextEdit() {
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.tintColor = UIColor.lightGray
        passwordField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        
        passwordField.backgroundColor = .white
        passwordField.text = self.account.password
        passwordField.placeholder = "Password"
        passwordField.textColor = UIColor.gray
        passwordField.layer.cornerRadius = 7.0
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 1.0
        
        passwordField.isEnabled = false
        
        self.view.addSubview(passwordField)
        self.passwordField.delegate = self
        
        passwordField.widthAnchor.constraint(equalToConstant: 325).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 10).isActive = true
    }

    func displayAccount() {
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
        accountDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 3)).isActive = true
    }
    
    @objc private func toggleNavButtons() {
        
        navigationItem.rightBarButtonItem?.title = navigationItem.rightBarButtonItem?.title == "Edit" ? "Done" : "Edit"
        if navigationItem.rightBarButtonItem?.title == "Done" {
            navigationItem.setHidesBackButton(true, animated:true)
        
            usernameField.isEnabled = true
            usernameField.textColor = UIColor.black
            
            
            passwordField.isEnabled = true
            passwordField.textColor = UIColor.black
            
            
        } else {
            navigationItem.setHidesBackButton(false, animated:true)
            usernameField.isEnabled = false
            usernameField.textColor = UIColor.gray
            
            
            passwordField.isEnabled = false
            passwordField.textColor = UIColor.gray
            
            
            //you should make the adjustment to the data
            self.account.username = usernameField.text!
            self.account.password = passwordField.text!
            
            //changed to vars but wont persist between app restarts
        
            
        }
    }

}
