//
//  SecondViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/15/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

var accounts = ["Apple ID", "Gatech", "Amazon", "Netflix"]
var accountInfo = ["id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah", "id: blahblah / pswrd: blahblah"]
var passwords = [""]


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(accounts)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = accounts[indexPath.row]
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let vc = segue.destination as! ViewController
            vc.index = selectedIndex
        }
    }
    
}
