//
//  AddViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

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
        //self.account.textColor = UIColor.black
        return false
    }
    
    /// Toggles IBOutlet Borders for dev purposes
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
    
    @IBOutlet var askUser: UILabel!

    @IBOutlet var account: UITextField!
    
    var accountName:String = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [ blue.cgColor, UIColor.white.cgColor]
        //layer.startPoint = CGPoint(x: 0, y: 0)
        //layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        
        navigationItem.hidesBackButton = true
        
        let rightBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.setupHideKeyboardOnTap()
        
        self.createAskUser()
        self.setupAccountTextEdit()
        
        self.devBorders(devBordersOn: false)
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
        
        account = UITextField()
        
        account.translatesAutoresizingMaskIntoConstraints = false
        
        account.tintColor = UIColor.lightGray
        account.setIcon(#imageLiteral(resourceName: "icon-account"))
        
        account.backgroundColor = .white
        account.placeholder = "Account"
        account.layer.cornerRadius = 7.0
        
        self.view.addSubview(account)
        self.account.delegate = self
        
        account.widthAnchor.constraint(equalToConstant: 325).isActive = true
        account.heightAnchor.constraint(equalToConstant: 40).isActive = true
        account.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        account.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    
    
    
    /// Implementing Inline Autocomplete
    
    var autoCompletePossibilities = ["Apple", "Pineapple", "Orange"]
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 {
            resetValues()
        } else {
            searchAutocompleteEntriesWithSubstring(substring: subString)
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        account.text = ""
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring)
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (Timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery: userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
                })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (Timer) in
                self.account.text = substring
            })
            
            autoCompleteCharacterCount = 0
        }
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String] {
        var possibleMatches: [String] = []
        for item in autoCompletePossibilities {
            let mystring:NSString! = item as NSString
            let substringRange:NSRange! = mystring.range(of: userText)
            
            if (substringRange.location == 0) {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery: String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray], range: NSRange(location: userQuery.count, length: autocompleteResult.count))
        self.account.attributedText = colouredString
    }
    
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.account.position(from: self.account.beginningOfDocument, offset: userQuery.count) {
            self.account.selectedTextRange = self.account.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = account.selectedTextRange
        account.offset(from: account.beginningOfDocument, to: (selectedRange?.start)!)
    }

    
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
    autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    /// End Implementation
    
    
    
    
    
    ///Add Button Action
    @objc func nextButtonAction(_ sender: UIBarButtonItem!) {
        
        accountName = account.text!
        
        let userVC = AddUserVC()
        userVC.hero.isEnabled = true
        
        self.hero.isEnabled = true
        
        userVC.hero.isEnabled = true
        
        // this configures the built in animation
        userVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        
        userVC.key = accountName
        
        navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
        
        navigationController?.pushViewController(userVC, animated: true)
    }
}
