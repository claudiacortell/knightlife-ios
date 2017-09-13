//
//  Storage.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class Storage
{
	static let userdefaults: UserDefaults!
	
	init()
	{
		Storage.userdefaults = UserDefaults(suiteName: "group.vishnu.squad.widget")
	}
}
