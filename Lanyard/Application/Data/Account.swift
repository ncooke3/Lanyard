//
//  Account.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 6/26/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//
import UIKit

class Account: NSObject, NSCoding {
    
    let service: String
    var username: String
    var password: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(service)
        aCoder.encode(username)
        aCoder.encode(password)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let service = aDecoder.decodeObject() as? String,
            var username = aDecoder.decodeObject() as? String,
            var password = aDecoder.decodeObject() as? String else {
                return nil
        }
        
        self.service = service
        self.username = username
        self.password = password
        
    }
    
    init(service: String, username: String, password: String) {
        self.service = service
        self.username = username
        self.password = password
    }
    
}

struct Defaults {
    
    static private let accountsKey = "accountsKey"
    
    static var accounts: [Account] = {
        
        guard let data = UserDefaults.standard.data(forKey: accountsKey) else { return [] }
        
        let accounts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Account] ?? []
        return accounts
        
        }() {
        didSet {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: accounts, requiringSecureCoding: false) else {
                return
            }
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }
    
}
