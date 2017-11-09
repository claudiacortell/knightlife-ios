//
//  Module.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/8/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class Module<ModuleManager: Manager>
{
	let manager: ModuleManager
	let name: String
	
	init(manager: ModuleManager, name: String)
	{
		self.manager = manager
		self.name = name
	}
}
