//
//  AddPasswordVC.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

//extension UIViewController {
//    /// Dismisses open keyboards by tapping anywhere in vc
//    func setupHideKeyboardOnTap() {
//        self.view.addGestureRecognizer(self.endEditingRecognizer())
//
//        self.navigationController?.navigationBar
//            .addGestureRecognizer(self.endEditingRecognizer())
//    }
//
//    /// Dismisses the keyboard from self.view
//    private func endEditingRecognizer() -> UIGestureRecognizer {
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
//        tap.cancelsTouchesInView = false
//        return tap
//    }
//}

class AddPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var password: UITextField!
    
    var userName:String = ""
    var key = ""
    
    var pswrd:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        
        //self.navigationItem.rightBarButtonItem.
        
        view.backgroundColor = .orange
        
        print("Password")
        print(key)
        print(userName)
        //        self.setupHideKeyboardOnTap()
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popVC)))
        
        
        ///Add Button Setup
        let moveButton = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(moveButtonAction2))
        
        
        self.navigationItem.rightBarButtonItem = moveButton
        
        
        ///TextEdit Setup
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        password = UITextField(frame: CGRect(x: (displayWidth / 2) - 75, y: (displayHeight / 2) - 50, width: 200, height: 50))
        
        
        password.backgroundColor = .clear
        password.placeholder = "Enter Password Name..."
        
        //adds to view & creates delegate
        self.view.addSubview(password)
        self.password.delegate = self
    }
    
    @objc func popVC() {
        print("called popVC")
        self.navigationController?.popViewController(animated: false)
    }
    
    
    ///Add Button Action
    @objc func moveButtonAction2() {
        print("Button Tapped")

        pswrd = password.text!

        accountsDict[key] = [userName, pswrd]
        accountsKeys.append(key)


        let mainVC = MainViewController()
        mainVC.hero.isEnabled = true

        self.hero.isEnabled = true
        mainVC.hero.isEnabled = true

        mainVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .right), dismissing: .slide(direction: .down))

        // lastly, present the view controller like normal
        //self.popVC()

        //self.present(mainVC, animated: true, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
        
        navigationController?.pushViewController(mainVC, animated: true)
        //navigationController?.popViewController(animated: true)
    }
    
//    ///Add Button Action
//    @objc func moveButtonAction(sender: UIButton!) {
//        print("Button Tapped")
//
//        //let accountVC = AddAccountVC()
//
//        let mainVC = UINavigationController(rootViewController: MainViewController())
//        mainVC.hero.isEnabled = true
//        //self.navigationController?.pushViewController(accountVC, animated: true)
//
//        //        accountsDict[accountName] = [nil, nil]
//        //        accountsKeys.append(accountName)
//
//        // this enables Hero
//        self.hero.isEnabled = true
//        mainVC.hero.isEnabled = true
//
//        // this configures the built in animation
//        //    vc2.hero.modalAnimationType = .zoom
//        //    vc2.hero.modalAnimationType = .pageIn(direction: .left)
//        //    vc2.hero.modalAnimationType = .pull(direction: .left)
//        //    vc2.hero.modalAnimationType = .autoReverse(presenting: .pageIn(direction: .left))
//        mainVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
//
//        // lastly, present the view controller like normal
//        //self.popVC()
//
//        self.present(mainVC, animated: true, completion: nil)
//    }
//
    
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
        textField.resignFirstResponder()
        return false
    }
}

