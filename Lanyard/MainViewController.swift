//
//  ViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

var accountsDict: [String: [String]] = [:]
var accountsKeys = [String]()

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    private var selectedIndex = 0
    private var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewWillAppear(true)
        
        print(accountsDict)
        
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: AddUserVC.classForCoder()) {
                    print("AddUseris in stack")
                    //Your Process
                } else {
                    print("first success")
                }

                if vc.isKind(of: AddUserVC.classForCoder()) {
                    print("AddUseris in stack")
                    //Your Process
                } else {
                    print("second success")
                }

                if vc.isKind(of: AddPasswordVC.classForCoder()) {
                    print("AddPassword is in stack")
                    //Your Process
                } else {
                    print("third success")
                }
            }
        }
        
        
        ///TableView setup
    
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
            //tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        tableView = UITableView(frame: CGRect(x: 0, y: 130, width: displayWidth, height: displayHeight - 100))
        
            //add constraints
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        

        ///Label Setup
        let lanyardLabel = UILabel(frame: CGRect(x: 20, y: 80, width: 100, height: 20))
        
        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0
        
        
        lanyardLabel.text = "Lanyard"
        lanyardLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        lanyardLabel.sizeToFit()
        
        self.view.addSubview(lanyardLabel)
        
        ///Add Button Setup
        let addButton = UIButton(frame: CGRect(x: 310, y: 65, width: 60, height: 65))
        
        //border for dev
        //addButton.layer.borderColor = UIColor.orange.cgColor
        //addButton.layer.borderWidth = 1.0
        
        addButton.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1) //color from Lanyard icon
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        addButton.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
            ///make it highlight when selected
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        
        ///Background
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1) //color from Lanyard icon

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    ///Add Button Action
    @objc func addButtonAction(sender: UIButton!) {
        print("Button Tapped")
        
        let accountVC = AddAccountVC()
        
        accountVC.hero.isEnabled = true

        // enables Hero
        self.hero.isEnabled = true
        accountVC.hero.isEnabled = true

        // this configures the built in animation
        //    vc2.hero.modalAnimationType = .zoom
        //    vc2.hero.modalAnimationType = .pageIn(direction: .left)
        //    vc2.hero.modalAnimationType = .pull(direction: .left)
        //    vc2.hero.modalAnimationType = .autoReverse(presenting: .pageIn(direction: .left))
        accountVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        
        navigationController?.pushViewController(accountVC, animated: true)
        
    }
    
    ///TableView Implementation

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsDict.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
 
        cell.textLabel?.text = accountsKeys[indexPath.row]
        return cell
     }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            accountsDict.removeValue(forKey: accountsKeys[indexPath.row])
            accountsKeys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    ///Prepare for Segue -> DetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let vc = segue.destination as! DetailVC
            vc.key = accountsKeys[selectedIndex]
            print("a")
        }
    }

}
