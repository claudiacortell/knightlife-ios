//
//  PreferenceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

protocol PreferenceHandler
{
	var storageKey: String { get }
	
	func getStorageValues() -> Any?
	func readStorageValues(data: Any)
	func loadDefaultValues()
}
