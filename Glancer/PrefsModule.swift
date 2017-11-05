//
//  PrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

protocol PrefsModule
{
	associatedtype Target
	associatedtype PrefsManager: Manager

	var storageKey: String { get }
	var manager: PrefsManager { get set }
	
	func getStorageValues() -> Any?
	func readStorageValues(data: Any)
}
