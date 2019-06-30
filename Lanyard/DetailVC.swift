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
        
        if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
        
        self.setLogo(company: CompanyDefaults.companies[account.service]!)
        
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
        //self.displayAccount()
        self.setupUserTextEdit()
        self.setupPasswordTextEdit()
        view.addSubview(scrollView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
    }
    
    func setLogo(company: Company) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 115, height: 115), scaleMode: .fill)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 115, height: 115))
        logoImageView.sd_setImage(with: company.logoURL,
                             placeholderImage: nil, context: [.imageTransformer: transformer],
                             progress: nil,
                             completed: { (image, error, cacheType, imageURL) in
                                if (error != nil) { print(error!) }
                                if (image == nil) {
                                    print("image is nil")
                                    return
                                }
                                if (company.brandColor == nil) {
                                    self.setCompanyColor(companyName: company.name, image: image!)
                                }
                                self.addLogoToView(logo: logoImageView)
                                self.setBackground(companyName: company.name, imageView: logoImageView)
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

    func addLogoToView(logo: UIImageView) {
        logo.layer.cornerRadius = logo.frame.size.width / 2;
        logo.layer.borderWidth = 4.0
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.backgroundColor = UIColor.white.cgColor
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
        let appleLightGrayInt = UInt(UIColor.lightGray.toHexString().dropFirst(), radix: 16)!

        let colors = image.getColors()
        var brandColor = UIColor(cgColor: (colors?.background.cgColor) ?? UIColor.lightGray.cgColor)
        let brandColorInt = UInt(brandColor.toHexString().dropFirst(), radix: 16)!
        if brandColorInt > appleLightGrayInt {
            brandColor = UIColor(cgColor: UIColor.lightGray.cgColor)
        }
        CompanyDefaults.companies[companyName]?.brandColor = brandColor.toHexString()
    }
    
    func setBackground(companyName: String, imageView: UIImageView) {
        let bgColor = UIColor.init(hexString: CompanyDefaults.companies[companyName]!.brandColor!)
        navigationController?.navigationBar.barTintColor = bgColor
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        layer.backgroundColor = bgColor?.cgColor
        view.layer.insertSublayer(layer, below: imageView.layer)
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
        
//        accountDisplay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        accountDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        accountDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 3)).isActive = true

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
        //super.willMove(toParent: parent)
        self.navigationController?.navigationBar.barTintColor = blue
    }

}
