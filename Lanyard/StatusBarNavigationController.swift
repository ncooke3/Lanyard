//
//  StatusBarNavigationController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 1/25/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class StatusBarNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    

}
