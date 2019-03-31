//
//  AddViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIViewController {
    
    /// Dismisses open keyboards by tapping anywhere in vc
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())

        self.navigationController?.navigationBar
            .addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    /// Dismisses keyboard when 'return' is tapped
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.accountField.textColor = UIColor.black
        return false
    }
    
    /// Toggles Borders for dev purposes
    @objc func devBorders(devBordersOn : Bool) {
        if (devBordersOn == true) {
            for item in view.subviews {
                item.layer.borderColor = UIColor.orange.cgColor
                item.layer.borderWidth = 1.0
            }
        }
    }
}

class AddAccountVC: UIViewController, UITextFieldDelegate {
    
    var askUser: UILabel!

    let accountField = UISuggestionTextField()
    
    var accountName:String = ""
    
    var currentSuggestion: String = "" {
        didSet {
            accountField.suggestionText = currentSuggestion
        }
    }
    
    
    private var request: Request? {
        didSet {
            oldValue?.cancel()
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ blue.cgColor, UIColor.white.cgColor]
        view.layer.addSublayer(layer)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        
        let rightBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    
        
        self.setupHideKeyboardOnTap()
        
        self.createAskUser()
        self.setupAccountTextEdit()
        
        self.devBorders(devBordersOn: false)
        
        self.accountField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        
    }
    
    var userText = ""
    
    @objc private func textDidChange(textField: UITextField) {
       self.accountField.textChanged()
        
        userText = textField.text ?? ""
        
        navigationItem.rightBarButtonItem?.isEnabled = !userText.isEmpty
        
        if userText.lowercased() != currentSuggestion.lowercased().dropLast(max(currentSuggestion.count - userText.count, 0)) {
            currentSuggestion = ""
        }
        
        setRecommendation(for: userText)
    }
    
    @objc func createAskUser() {
        askUser = UILabel()
        
        askUser.translatesAutoresizingMaskIntoConstraints = false
        
        askUser.text = "What's the account?"
        askUser.textAlignment = .center
        askUser.font = UIFont.boldSystemFont(ofSize: 30.0)
        askUser.textColor = UIColor.gray
        
        askUser.backgroundColor = .white
        askUser.layer.backgroundColor = UIColor.white.cgColor
        askUser.layer.cornerRadius = 7.0
        askUser.layer.masksToBounds = true
        
        self.view.addSubview(askUser)
        
        askUser.widthAnchor.constraint(equalToConstant: 300).isActive = true
        askUser.heightAnchor.constraint(equalToConstant: 100).isActive = true
        askUser.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        askUser.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -225).isActive = true
    }
    
    @objc func setupAccountTextEdit() {
        
        accountField.translatesAutoresizingMaskIntoConstraints = false
        
        accountField.tintColor = UIColor.lightGray
        accountField.setIcon(#imageLiteral(resourceName: "icon-account"))
        
        
        accountField.backgroundColor = .white
        accountField.placeholder = "Account"
        accountField.layer.cornerRadius = 7.0
        
        self.view.addSubview(accountField)
        self.accountField.delegate = self
        
        accountField.widthAnchor.constraint(equalToConstant: 325).isActive = true
        accountField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        accountField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func setRecommendation(for text : String) {
        guard !text.isEmpty else {
            request?.cancel()
            currentSuggestion = ""
            return
        }
        
        
        //make suggestion text label the first bit should be what the user has already written then after that display the rest of the suggestion
        //when what the user has written doesnt match the suggestion than it will still look correct i.e capital E thing
        
        //user types vharacter that doesnt match up with next charcater in suggestion you need to hide suggestion immediately and show (textDidChange if last letter of text != what /// set sugg to empty s
        
        
        request = Alamofire.request("https://autocomplete.clearbit.com/v1/companies/suggest?query=\(text)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let companyNames = json.array?.compactMap { $0["name"].string } ?? []
                self.currentSuggestion = self.recommendedSuggestions(for: companyNames)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func recommendedSuggestions(for suggestions: [String]) -> String {
        guard !userText.isEmpty else {
            return ""
        }
        return suggestions.first { $0.lowercased().hasPrefix(userText.lowercased()) } ?? ""
    }
    

    @objc override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = currentSuggestion
        return false
    }
    
    
    ///Add Button Action
    @objc func nextButtonAction(_ sender: UIBarButtonItem!) {
        
        accountName = accountField.text!
        
        let userVC = AddUserVC()
        
        userVC.key = accountName

        navigationController?.pushViewController(userVC, animated: true)
    }
}
