//
//  Manager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class Manager
{
    let name: String
    
    init(name: String)
    {
        self.name = name
        
        print("Loaded \(self.name)")
    }
}
