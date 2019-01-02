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
    
    private var selectedIndex = 0
    private var tableView: UITableView!
    private var cellsToDelete = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewWillAppear(true)
        
        ///Background
        view.backgroundColor = #colorLiteral(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1) //color from Lanyard icon
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleEditing)

        let rightBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addButtonAction(_:)))
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.createLanyardLabel()
        
        self.setupTable()
        
        print(accountsDict)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @objc func createLanyardLabel() {
        lanyardLabel = UILabel(frame: CGRect(x: 15, y: 85, width: 100, height: 20))
        lanyardLabel.text = "Lanyard"
        lanyardLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        lanyardLabel.sizeToFit()
        self.view.addSubview(lanyardLabel)
    }
    
    @objc func setupTable() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 130, width: displayWidth, height: displayHeight - 100))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = 50.0
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        tableView.allowsMultipleSelectionDuringEditing = true
        self.view.addSubview(tableView)
    }
    
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Delete" : "Add"
        
        navigationItem.rightBarButtonItem?.tintColor = tableView.isEditing ? .red : .white
        navigationItem.rightBarButtonItem?.isEnabled = tableView.isEditing ? false : true
        
        if !tableView.isEditing {
            cellsToDelete.removeAll()
        }
    }
    
    @objc func addButtonAction(_ sender: UIBarButtonItem!) {
        if (!tableView.isEditing) {
            
            let addTapped = """
                  Add was tapped.

                  """
            print(addTapped)
            
            let accountVC = AddAccountVC()
            
            accountVC.hero.isEnabled = true

            // enables Hero
            self.hero.isEnabled = true
            accountVC.hero.isEnabled = true
            
            navigationController?.hero.navigationAnimationType = .zoomSlide(direction: .left)
            
            navigationController?.pushViewController(accountVC, animated: true)
            
            
            
        } else {
            
            let deleteTapped = """
                  Delete was tapped.

                  """
            print(deleteTapped)
            
            print("CTD before for-loop: \(cellsToDelete)\n")
            
            for item in cellsToDelete.reversed() {
                let removedKey = accountsKeys.remove(at: item)
                accountsDict.removeValue(forKey: removedKey)
            }
            
            print("CTD after for-loop: \(cellsToDelete)\n")
            
            print("Backing dict: \(accountsDict)\n")
            
            cellsToDelete.removeAll()
            
            print("CTD after clean: \(cellsToDelete)\n")
            
            tableView.reloadData()
            
            self.toggleEditing()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        if (tableView.isEditing != true) {
            let detailVC = DetailVC()
            detailVC.hero.isEnabled = true
            
            self.hero.isEnabled = true
            
            detailVC.hero.isEnabled = true
            
            detailVC.key = accountsKeys[selectedIndex]
            
            navigationController?.hero.navigationAnimationType = .zoom
            
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DidSelect called: \(cellsToDelete)\n")
            if (cellsToDelete.contains(selectedIndex)) {
                print("CTD contains selectedIndex!")
                cellsToDelete.remove(at: selectedIndex)
                print("After removal, CTD: \(cellsToDelete)\n")
            } else {
                if (cellsToDelete.count == 0) {
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
                print("CTD DOES NOT contain selectedIndex!")
                cellsToDelete.append(selectedIndex)
                print("After adding, CTD: \(cellsToDelete)\n")
            }
        }
        
    }
    
    ///TableView Implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsDict.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("didDESELECT called: \(cellsToDelete)\n")
        
        if (cellsToDelete.contains(selectedIndex)) {
            print("CTD contains selectedIndex!")
            cellsToDelete = cellsToDelete.filter({ $0 != selectedIndex })
            print("After removal, CTD: \(cellsToDelete)\n")
        }
        
        if (cellsToDelete.count == 0) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        print("Exit didDESELECT\n")
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
 
        cell.textLabel?.text = accountsKeys[indexPath.row]
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 18)
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            accountsDict.removeValue(forKey: accountsKeys[indexPath.row])
            accountsKeys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
