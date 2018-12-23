//
//  HeroViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Hero

class HeroViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CGRectMake has been deprecated - and should be let, not var
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        
        // you will probably want to set the font (remember to use Dynamic Type!)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        // and set the text color too - remember good contrast
        label.textColor = .white
        
        // may not be necessary (e.g., if the width & height match the superview)
        // if you do need to center, CGPointMake has been deprecated, so use this
        label.center = CGPoint(x: 160, y: 284)
        
        // this changed in Swift 3 (much better, no?)
        label.textAlignment = .center
        
        label.text = "I am a test label"
        
        self.view.addSubview(label)

    }
    

}
