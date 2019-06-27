//
//  Company.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 6/26/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit
import Foundation


struct Company: Codable {
    var name : String
    var initials : String?
    var logoURL : URL?
    var brandColor : String?
}

struct CompanyDefaults {
    
    static private let companiesKey = "companiesKey"
    
    static var companies: [String:Company] = {
        
        guard let data = UserDefaults.standard.data(forKey: companiesKey) else { return [:] }
        return try! JSONDecoder().decode([String:Company].self, from: data) ?? [:]
        }() {
        didSet {
            guard let data = try? JSONEncoder().encode(companies) else { return }
            UserDefaults.standard.set(data, forKey: companiesKey)
        }
    }
}
