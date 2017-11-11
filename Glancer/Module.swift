//
//  Module.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/8/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class Module<ModuleManager: Manager>: IModule
{	
	private(set) var nameAbs: String
	
	let manager: ModuleManager
	var nameComplete: String { return "\(manager.name)-\(nameAbs)" }
	
	init(_ manager: ModuleManager, name: String)
	{
		self.manager = manager
		self.nameAbs = name
	}
    
    func out(_ text: String)
    {
        self.manager.out("\(self.nameAbs) - \(text)")
    }
}
