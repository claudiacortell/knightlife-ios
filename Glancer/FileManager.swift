//
//  FileManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class FileManager: Manager
{
    static let userDefaults = UserDefaults.standard
    
    let dataTree: String
    
    required init(name: String, dataTree: String)
    {
        self.dataTree = dataTree
        
        super.init(name: name)
    }
    
    func loadUserData() { /* Override point */ }
    func saveUserData() { /* Override point */ }

}
