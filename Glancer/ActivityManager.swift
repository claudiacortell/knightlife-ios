//
//  ActivityManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ActivityManager: FileManager
{
    static let instance = ActivityManager()
    
    var activities: [Activity]
    
    init()
    {
        self.activities = []
    }
    
    
}
