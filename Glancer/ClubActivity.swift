//
//  ClubActivity.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ClubActivity: Activity
{
    var room: String? // Room #
    
    init(name: String)
    {
        super.init(type: .club, name: name)
    }
}
