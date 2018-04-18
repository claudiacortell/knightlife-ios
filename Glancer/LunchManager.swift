//
//  LunchManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class LunchManager: Manager {
	
	static let instance = LunchManager()
	
	var menuHandler: GetMenuResourceHandler!
	
	init() {
		super.init("Lunch Manager")
		
		self.menuHandler = GetMenuResourceHandler(self)
	}
	
}
