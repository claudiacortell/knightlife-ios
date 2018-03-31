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
	private let defaults = UserDefaults(suiteName: "MAD.BBN.KnightLife.Group")!
	
    private init()
    {
        
    }
    
	func saveMod(_ module: PreferenceHandler)
	{
		defaults.set(module.getStorageValues(), forKey: module.storageKey)
	}
	
	func loadMod(_ module: PreferenceHandler)
	{
		if let object = defaults.object(forKey: module.storageKey)
		{
			module.readStorageValues(data: object)
		} else
		{
			module.loadDefaultValues()
		}
	}
}
