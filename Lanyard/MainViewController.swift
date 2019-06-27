//
//  ViewController.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 12/22/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit

let blue = UIColor.init(red: 0.003026410937, green: 0.6117492318, blue: 1, alpha: 1)


class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationController?.navigationBar.barTintColor = blue

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = blue
        navigationItem.largeTitleDisplayMode = .always
        
        self.title = "Lanyard"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.action = #selector(toggleEditing)
        editButtonItem.tintColor = UIColor.white

        let rightBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addButtonAction(_:)))
        rightBarButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButton
        self.setupTable()
        
        print(Defaults.accounts)
    }
    
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    @objc func setupTable() {
        tableView = UITableView(frame: .zero)
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
    }
    
    @objc func addButtonAction(_ sender: UIBarButtonItem!) {
        if (!tableView.isEditing) {
            let accountVC = AddAccountVC()
            let navigationController = UINavigationController(rootViewController: accountVC)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            for item in (tableView.indexPathsForSelectedRows?.map({$0.row}) ?? []) {
                Defaults.accounts.remove(at: item)
                print("Delete!")
                print(Defaults.accounts)
            }
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            self.toggleEditing()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView.indexPathsForSelectedRows?.isEmpty ?? true) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing != true) {
            let detailVC = DetailVC(account: Defaults.accounts[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
    }
    
    ///TableView Implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults.accounts.count
    }
    

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Defaults.accounts[indexPath.row].service
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 18)
        return cell
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Defaults.accounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //🐞if i add, delete, and then STOP and rebuild. it will still be there?
            print("Delete!")
            print(Defaults.accounts)
        }
    }
}
