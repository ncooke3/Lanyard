//
//  TestViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 1/25/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    let tableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Test"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white
        
        
        navigationController?.navigationBar.isTranslucent = false
        view.addSubview(tableView)
    
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
