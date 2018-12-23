//
//  ViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

var accountsDict: [String: [String]] = [:]
var accountsKeys = [String]()

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    private var selectedIndex = 0
    private var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        //appsTableView?.reloadData()
        print(accountsDict)
        
        ///TableView setup
    
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
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
        let lanyardLabel = UILabel(frame: CGRect(x: 20, y: 90, width: 100, height: 20))
        
        //border for dev
        lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        lanyardLabel.layer.borderWidth = 1.0;
        
        
        lanyardLabel.text = "Lanyard"
        lanyardLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        lanyardLabel.sizeToFit()
        
        self.view.addSubview(lanyardLabel)
        
        ///Background
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1) //color from Lanyard icon

    }
    
    ///TableView Implementation

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsDict.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
 
        cell.textLabel?.text = accountsKeys[indexPath.row]
        print("c")
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
