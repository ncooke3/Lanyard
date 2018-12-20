//
//  ViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/14/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var index : Int = 0

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = accounts[index]
        infoLabel.text = accountInfo[index]
    }


}

