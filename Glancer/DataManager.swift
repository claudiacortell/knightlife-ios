//
//  DataManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class DataManager<Module: PrefsModule>: Manager
{
	let dataModule: Module
	
	init(name: String, registerEvents: Bool = true, module: Module)
	{
		self.dataModule = module
		
		super.init(name: name, registerEvents: registerEvents)
	}
	
	func loadDataModule()
	{
		PrefsOverlord.instance.load(self.dataModule)
	}
	
	func saveDataModule()
	{
		PrefsOverlord.instance.save(self.dataModule)
	}
}
