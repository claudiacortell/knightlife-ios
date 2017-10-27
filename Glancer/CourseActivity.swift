//
//  CourseActivity.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class CourseActivity: Activity
{
    var room: String? // Room #
    var teacher: String? // Teacher name.
    
    init(name: String)
    {
        super.init(type: .course, name: name)
    }
}
