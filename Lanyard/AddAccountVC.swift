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


}

class AddAccountVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterAccountName: UITextField!

    @IBOutlet weak var enterUsername: UITextField!

    @IBOutlet weak var enterPassword: UITextField!

    @IBAction func addAccount(sender: UIButton) {

        let accountName = enterAccountName.text!
        let username = enterUsername.text!
        let password = enterPassword.text!

        ///create a better way to handle cases where usr doesnt properly enter text
        if (accountName != "" && username != "" && password != "") {
            accountsDict[accountName] = [username, password]
            accountsKeys.append(accountName)
        }

    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.setupHideKeyboardOnTap()

        self.enterAccountName.delegate = self
        self.enterUsername.delegate = self
        self.enterPassword.delegate = self
    }

    //////////////////////////////////////////////////////////////
//    @IBAction func heroTest(_ sender: Any) {
//        let vc2 = HeroViewController1()
//
//
//        // this enables Hero
//        vc2.hero.isEnabled = true
//
//        // this configures the built in animation
//        //    vc2.hero.modalAnimationType = .zoom
//        //    vc2.hero.modalAnimationType = .pageIn(direction: .left)
//        //    vc2.hero.modalAnimationType = .pull(direction: .left)
//        //    vc2.hero.modalAnimationType = .autoReverse(presenting: .pageIn(direction: .left))
//        vc2.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
//
//        // lastly, present the view controller like normal
//
//        self.present(vc2, animated: true, completion: nil)
//
//    }
//
//    //////////////////////////////////////////////////////////////
//    @IBAction func SBtest(_ sender: Any) {
//        view.hero.id = "test"
//        performSegue(withIdentifier: "segue1", sender: self)
//    }
//
//
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if (segue.identifier == "segue1") {
////            //let vc = segue.destination as! SBViewController
////        }
////    }

    //////////////////////////////////////////////////////////////

    /// Tabs to next textboc or dismisses keyboard when 'return' is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == enterAccountName {
            textField.resignFirstResponder()
            enterUsername.becomeFirstResponder()
        } else if (textField == enterUsername) {
            textField.resignFirstResponder()
            enterPassword.becomeFirstResponder()
        } else if (textField == enterPassword) {
            self.view.endEditing(true)
            return false
        }

        return true

    }

}
