//
//  DetailVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

import Alamofire
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
        imageView.layer.cornerRadius = 0
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
    
    let scrollView: UIScrollView = {
        let scroller = UIScrollView()
        //scroller.backgroundColor = .green
        scroller.isScrollEnabled = false
        scroller.translatesAutoresizingMaskIntoConstraints = false
        return scroller
    }()
    
    let containerView: UIView = {
        let view = UIView()
        //view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: (view.safeFrame.width * 0.35) - 5, height: (view.safeFrame.width * 0.35) - 1), scaleMode: .fill)
        logoImageView.sd_setImage(with: CompanyDefaults.companies[account.service]?.logoURL, placeholderImage: nil, options: [], context: [.imageTransformer: transformer])
        
        bannerLayer = createBannerLayer()
        
        if let bgColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            setNavBarAndBackgroundColor(bgColor: bgColor)
        }
        
        view.layer.addSublayer(bannerLayer)
        view.addSubview(logoImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(usernameField)
        containerView.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            logoImageView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.safeFrame.height * 0.14),
            logoImageView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: view.safeFrame.width * 0.35),
            logoImageView.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.35)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: view.safeFrame.height * 0.30),
            scrollView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.safeFrame.width),
            scrollView.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.30)
            ])
        
        NSLayoutConstraint.activate([
            containerView.safeTopAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: scrollView.safeLeadingAnchor),
            containerView.widthAnchor.constraint(equalToConstant: view.safeFrame.width),
            containerView.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.33),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
        
        usernameField.text = self.account.username
        self.usernameField.delegate = self
        NSLayoutConstraint.activate([
            usernameField.safeTopAnchor.constraint(equalTo: containerView.topAnchor, constant: 55),
            usernameField.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.05),
            usernameField.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.85)
        ])
        
        passwordField.text = self.account.password
        self.passwordField.delegate = self
        NSLayoutConstraint.activate([
            passwordField.safeTopAnchor.constraint(equalTo: usernameField.safeBottomAnchor, constant: view.safeFrame.height * 0.07),
            passwordField.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: view.safeFrame.height * 0.05),
            passwordField.widthAnchor.constraint(equalToConstant: view.safeFrame.width * 0.85)
            ])
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleNavButtons)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navBarColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: https://twitter.com/nathangitter/status/992842150500069376
        if (logoImageView.layer.cornerRadius == 0) {
            logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        }
        
        if CompanyDefaults.companies[account.service]?.brandColor == nil {
            
            if let logo = logoImageView.image {
                setCompanyColor(image: logo)
            }
        
            if let bgColor = UIColor.init(hexString: CompanyDefaults.companies[account.service]?.brandColor ?? "") {
                setNavBarAndBackgroundColor(bgColor: bgColor)
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
        guard let userInfo = notification.userInfo else { return }
        guard let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue.size
        
        var obscuredRect: CGRect = self.view.safeFrame;
        obscuredRect.origin.y += self.view.safeFrame.height - keyboardFrame.height;
        
        let activeTextField: UITextField? = [ usernameField, passwordField ].first { $0.isFirstResponder }
        if let textField = activeTextField {
            let textFieldFrameRelativeToSuperView = view.convert(textField.frame, from: textField.superview)
            if obscuredRect.contains(textFieldFrameRelativeToSuperView) {
                let verticalScrollingOffset = 50
                let scrollToPoint = CGPoint(x: 0, y: verticalScrollingOffset)
                UIView.animate(withDuration: animationDuration, animations: {
                    self.scrollView.setContentOffset(scrollToPoint, animated: false)
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        let scrollToPoint = CGPoint(x: 0, y: 0)
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollView.setContentOffset(scrollToPoint, animated: false)
        })
    }

    // TODO: Create PlaceHolder and set as default!
    func createPlaceHolder(companyName: String) -> UIImageView {
        return UIImageView()
    }
    
    func setCompanyColor(image: UIImage) {
        let colors = image.getColors()
        var brandColor = UIColor(cgColor: (colors?.background.cgColor) ?? UIColor.lightGray.cgColor)
        if (brandColor.toHexString() == "#ffffffff") {
            brandColor = UIColor.lightGray
        }
        CompanyDefaults.companies[account.service]?.brandColor = brandColor.toHexString()
    }
    // TODO:Animate initial color change
    func setNavBarAndBackgroundColor(bgColor: UIColor) {
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.bannerLayer.backgroundColor = bgColor.cgColor
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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.navigationController?.navigationBar.barTintColor = blue
    }
}
