//
//  ViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/14/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var key : String = ""
    
    @IBOutlet weak var accountName: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var password: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accountName.text = key
        username.text = accountsDict[key]?[0]
        password.text = accountsDict[key]?[1]
    }


}

