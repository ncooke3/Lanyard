//
//  SecondViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

//var accounts = ["Apple ID", "Gatech", "Amazon", "Netflix"]
var accountInfo = ["id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah"]
var accountsDict: [String: [String]] = [:]
var accountsKeys = [String]()


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var selectedIndex = 0
    
    @IBOutlet var appsTableView : UITableView?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appsTableView?.reloadData()
        print(accountsDict)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return accountsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = accountsKeys[indexPath.row]
        print("c")
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let vc = segue.destination as! ViewController
            vc.key = accountsKeys[selectedIndex]
            print("a")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            accountsDict.removeValue(forKey: accountsKeys[indexPath.row])
            accountsKeys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
}
