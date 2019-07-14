//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.trailingAnchor
        }
        return self.trailingAnchor
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        }
        return self.leadingAnchor
    }
    
    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }
        return self.centerXAnchor
    }
    
    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }
        return self.centerYAnchor
    }
    
    var safeFrame: CGRect {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.layoutFrame
        }
        return self.frame
    }
}

import UIKit

import Alamofire
import AlamofireImage
import UIImageColors
import SwiftyJSON
import SDWebImage

class DetailVC: UIViewController, UITextFieldDelegate {
    let account: Account
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var accountDisplay: UILabel!
    private var request: Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Back"
        return button
    }()
    
    var bannerLayer = CALayer()
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.backgroundColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true // does this cause problems since subview added later?
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // TODO: Make a custom subclass for this Text Field
    let usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.textColor = UIColor.gray
        textField.setIcon(#imageLiteral(resourceName: "icon-user"))
        textField.tintColor = UIColor.lightGray
        textField.backgroundColor = .white
        
        textField.layer.cornerRadius = 7.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // TODO: Make a custom subclass for this Text Field
    let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = UIColor.gray
        textField.setIcon(#imageLiteral(resourceName: "icon-lock"))
        textField.tintColor = UIColor.lightGray
        textField.backgroundColor = .white
        
        textField.layer.cornerRadius = 7.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
        
        bannerLayer = createBannerLayer()
        view.layer.addSublayer(bannerLayer)
        view.addSubview(logoImageView)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: (view.safeFrame.width * 0.35) - 5, height: (view.safeFrame.width * 0.35) - 1), scaleMode: .fill)
        logoImageView.sd_setImage(with: CompanyDefaults.companies[account.service]?.logoURL, placeholderImage: nil, options: [], context: [.imageTransformer: transformer])
        
        NSLayoutConstraint.activate([
            logoImageView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.safeFrame.height * 0.15),
            logoImageView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: view.safeFrame.width * 0.35),
            logoImageView.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.35)
        ])
        
        usernameField.text = self.account.username
        self.usernameField.delegate = self
        NSLayoutConstraint.activate([
            usernameField.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: view.safeFrame.height * -0.40),
            usernameField.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.05),
            usernameField.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.85)
        ])
        
        
        passwordField.text = self.account.password
        self.passwordField.delegate = self
        NSLayoutConstraint.activate([
            passwordField.safeTopAnchor.constraint(equalTo: usernameField.safeBottomAnchor, constant: view.safeFrame.height * 0.06),
            passwordField.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.05),
            passwordField.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.85)
            ])
        
        navigationItem.largeTitleDisplayMode = .never // Why can do I not have to include navController?
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        
        if let logo = logoImageView.image {
            setCompanyColor(image: logo)
            if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
                UIView.animate(withDuration: 3.0, animations: {
                    self.navigationController?.navigationBar.barTintColor = navBarColor
                })
                setBackground()
            }
        }
    }
    
    func createBannerLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.safeFrame.height * 0.33)
        layer.backgroundColor = UIColor.lightGray.cgColor
        return layer
    }

    
    @objc func keyboardWillShow(_ notification: Notification) {
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
    }

    func createPlaceHolder(companyName: String) -> UIImageView {
        return UIImageView()
    }
    
    func setCompanyColor(image: UIImage) {
        let appleLightGrayInt = UInt(UIColor.lightGray.toHexString().dropFirst(), radix: 16)!
        let colors = image.getColors()
        var brandColor = UIColor(cgColor: (colors?.background.cgColor) ?? UIColor.lightGray.cgColor)
        let brandColorInt = UInt(brandColor.toHexString().dropFirst(), radix: 16)!
        if brandColorInt > appleLightGrayInt {
            brandColor = UIColor(cgColor: UIColor.lightGray.cgColor)
        }
        CompanyDefaults.companies[account.service]?.brandColor = brandColor.toHexString()
    }
    
    func setBackground() {
        let bgColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]!.brandColor!)
        navigationController?.navigationBar.barTintColor = bgColor
        bannerLayer.backgroundColor = bgColor?.cgColor
    }
    
    // TODO: Maybe add a switch case for the two cases?
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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.navigationController?.navigationBar.barTintColor = blue
    }

}
