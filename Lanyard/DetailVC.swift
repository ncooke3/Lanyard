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
import SDWebImage

class DetailVC: UIViewController, UITextFieldDelegate {
    var accountDisplay: UILabel!
    private var request: Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    let usernameField = UITextField()
    let passwordField = UITextField()
    let scrollView = { () -> UIScrollView in
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    let account: Account
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem?.isEnabled = true
        /// BackButton Code
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.largeTitleDisplayMode = .never
        /// EditButton Code
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)
        
        self.setLogo(companyURL: CompanyDefaults.companies[account.service]!.logoURL!)
        
        self.displayAccount()
        self.setupUserTextEdit()
        self.setupPasswordTextEdit()
        view.addSubview(scrollView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setLogo(companyURL: URL) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 115, height: 115), scaleMode: .fill)
        let test = UIImageView(frame: CGRect(x: 0, y: 0, width: 115, height: 115))
        test.sd_setImage(with: companyURL,
                             placeholderImage: nil, context: [.imageTransformer: transformer],
                             progress: nil,
                             completed: { (image, error, cacheType, imageURL) in
                                print(cacheType.rawValue)
                                if (error != nil) {
                                    print(error!)
                                }
                                self.addLogoToView(logo: test)
        })
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        scrollView.isScrollEnabled = true
        UIKeyboardNotificationData.handleKeyboardWillShow(notification: notification, forScrollView: self.scrollView, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIKeyboardNotificationData.handleKeyboardWillHide(notification: notification, forScrollView: self.scrollView, animated: true)
        scrollView.isScrollEnabled = false
    }

    
    func createPlaceHolder(companyName: String) -> UIImageView {
        return UIImageView()
    }
    
    /*
    func handleThisMess(companyName: String) -> UIImageView {
        if ((CompanyDefaults.companies[companyName]?.logoURL == nil)) {
            noURL(companyName: companyName, completion: {imageView in
                return imageView
            })
        } else {
            hasURL(companyName: CompanyDefaults.companies[companyName]!.name, completion: {
                imageView in
                return imageView
            })
        }
        print("bad shit")
        return UIImageView()
    }


    
    
    func noURL(companyName: String, completion: @escaping (UIImageView) -> UIImageView) -> Void {
        let logoView = UIImageView()
        getLogoURL(service: companyName, completion: { apiURL in
            if let stringURL = apiURL {
                CompanyDefaults.companies[companyName]?.logoURL = URL(string: stringURL)
                let transformer = SDImageResizingTransformer(size: CGSize(width: 115, height: 115), scaleMode: .fill)
                logoView.sd_setImage(with: CompanyDefaults.companies[companyName]?.logoURL!,
                                     placeholderImage: nil, context: [.imageTransformer: transformer],
                                     progress: nil,
                                     completed: { (image, error, cacheType, imageURL) in
                                        if (image == nil) {
                                            completion(self.createPlaceHolder(companyName: (CompanyDefaults.companies[companyName]!.name)))
                                        } else {
                                            // Success! TODO: Check if came from cache...
                                            completion(logoView)
                                        }
                })
            } else {
                completion(self.createPlaceHolder(companyName: CompanyDefaults.companies[companyName]!.name))
            }
        })
    }
    
    
    func hasURL(companyName: String, completion: @escaping (UIImageView) -> UIImageView) -> Void {
        var logoView = UIImageView()
        let transformer = SDImageResizingTransformer(size: CGSize(width: 115, height: 115), scaleMode: .fill)
        logoView.sd_setImage(with: CompanyDefaults.companies[companyName]?.logoURL!,
                             placeholderImage: nil, context: [.imageTransformer: transformer],
                             progress: nil,
                             completed: { (image, error, cacheType, imageURL) in
                                if (image == nil) {
                                    logoView = self.createPlaceHolder(companyName: (CompanyDefaults.companies[companyName]!.name))
                                    completion(logoView)
                                } else {
                                    // Success! TODO: Check if came from cache...
                                    completion(logoView)
                                }
        })
    }
    */
    
    func addLogoToView(logo: UIImageView) {
        logo.layer.cornerRadius = logo.frame.size.width / 2;
        logo.layer.borderWidth = 4.0
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
    
    func setCompanyColor(companyName: String, image: UIImage) {
        let colors = image.getColors()
        let brandColor = UIColor(cgColor: (colors?.background.cgColor)!)
        CompanyDefaults.companies[companyName]?.brandColor = brandColor.toHexString()
    }
    
    func setBackground(companyName: String) {
        let bgColor = UIColor.init(hexString: CompanyDefaults.companies[companyName]!.brandColor!)
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        layer.backgroundColor = (bgColor as! CGColor)
        navigationController?.navigationBar.barTintColor = bgColor
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
        self.scrollView.addSubview(usernameField)
        self.usernameField.delegate = self

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
        self.scrollView.addSubview(passwordField)
        self.passwordField.delegate = self
        

    }

    func displayAccount() {
        accountDisplay = UILabel()
        accountDisplay.translatesAutoresizingMaskIntoConstraints = false
        accountDisplay.text = self.account.service
        accountDisplay.textAlignment = .center
        accountDisplay.font = UIFont.boldSystemFont(ofSize: 30.0)
        accountDisplay.textColor = .white
        accountDisplay.sizeToFit()
        self.scrollView.addSubview(accountDisplay)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: passwordField.frame.maxY
        )
        
        accountDisplay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        accountDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 3)).isActive = true

        usernameField.widthAnchor.constraint(equalToConstant: 325).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        usernameField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -75).isActive = true
        
        passwordField.widthAnchor.constraint(equalToConstant: 325).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        passwordField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: (scrollView.frame.height / 10) - 75).isActive = true

    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = blue
    }

}
