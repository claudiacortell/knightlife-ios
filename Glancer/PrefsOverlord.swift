//
//  PrefsOverlord.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class PrefsOverlord // All hail
{
	static let instance = PrefsOverlord()
	private let defaults = UserDefaults.standard
	
	func save<M: PrefsModule>(_ module: M)
	{
		defaults.set(module.getStorageValues(), forKey: key(module))
	}
	
	func load<M: PrefsModule>(_ module: M)
	{
		if let object = defaults.object(forKey: key(module))
		{
			module.readStorageValues(data: object)
		}
	}
	
	private func key<M: PrefsModule>(_ module: M) -> String
	{
		return "\(module.manager.name).\(module.storageKey)"
	}
}
