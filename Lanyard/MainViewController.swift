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

let blue = UIColor.init(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1)

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var lanyardLabel: UILabel!
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    private var selectedIndex = 0
    private var tableView: UITableView!
    private var cellsToDelete = [Int]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewWillAppear(true)
        
        ///Background
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1) //color from Lanyard icon
        
        self.createLanyardLabel()
        
        //self.makeAddButton()
        
        navigationController?.isNavigationBarHidden = false
        

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleEditing)

        let rightBarButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.addButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.setupTable()
        
        print(accountsDict)
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        // Takes care of toggling the button's title.
//        super.setEditing(!isEditing, animated: true)
//
//        // Toggle table view editing.
//        tableView.setEditing(!tableView.isEditing, animated: true)
//    }
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Delete" : "Add"
    }
    
    @objc func setupTable() {
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 130, width: displayWidth, height: displayHeight - 100))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        tableView.allowsMultipleSelectionDuringEditing = true
        self.view.addSubview(tableView)
    }
    
    ///Add Button Action
    @objc func addButtonAction(_ sender: UIBarButtonItem!) {
        if (!tableView.isEditing) {
            print("Add Tapped")
            
            let accountVC = AddAccountVC()
            
            accountVC.hero.isEnabled = true

            // enables Hero
            self.hero.isEnabled = true
            accountVC.hero.isEnabled = true
            
            navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
            
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            print("Delete tapped")
            
            print(cellsToDelete)
            
            
            for item in cellsToDelete.reversed() {
                let removedKey = accountsKeys.remove(at: item)
                accountsDict.removeValue(forKey: removedKey)
            }
            
            print(cellsToDelete)
            
            print(accountsDict)
            
            //tableView.deleteSections(IndexSet(cellsToDelete), with: .fade)
            
            cellsToDelete.removeAll()
            print(cellsToDelete)
            
            tableView.reloadData()
            
            self.toggleEditing()
            
        }
        
    }
    
    ///TableView Implementation

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsDict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
 
        cell.textLabel?.text = accountsKeys[indexPath.row]
        return cell
     }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        if (tableView.isEditing != true) {
            //performSegue(withIdentifier: "segue", sender: self)
            let detailVC = DetailVC()
            detailVC.hero.isEnabled = true
            
            // enables Hero
            self.hero.isEnabled = true
            
            detailVC.hero.isEnabled = true
            
            // this configures the built in animation
            
            detailVC.key = accountsKeys[selectedIndex]
            
            navigationController?.hero.navigationAnimationType = .zoom
            
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print(cellsToDelete)
            if (cellsToDelete.contains(selectedIndex)) {
                // play around with
                cellsToDelete.remove(at: selectedIndex)
                print(cellsToDelete)
            } else {
                cellsToDelete.append(selectedIndex)
                print(cellsToDelete)
            }
        }
        
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            accountsDict.removeValue(forKey: accountsKeys[indexPath.row])
            accountsKeys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func createLanyardLabel() {
        lanyardLabel = UILabel(frame: CGRect(x: 15, y: 85, width: 100, height: 20))
        
        //border for dev
        //lanyardLabel.layer.borderColor = UIColor.orange.cgColor
        //lanyardLabel.layer.borderWidth = 1.0
        
        lanyardLabel.text = "Lanyard"
        lanyardLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        lanyardLabel.sizeToFit()
        
        self.view.addSubview(lanyardLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("got it")
        tableView.reloadData()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let rightBarButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.addButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
