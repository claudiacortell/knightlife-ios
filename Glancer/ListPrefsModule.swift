//
//  ListPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

protocol ListPrefsModule: PrefsModule
{
	var items: [Target] { get }
	
	func containsItem(_ target: Target) -> Bool
	func addItem(_ target: Target, ignoreDuplicates: Bool) -> Bool
	func removeItem(_ target: Target) -> Bool
}
