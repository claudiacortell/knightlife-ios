//
//  CollectionModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/8/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class CollectionModule: Module<CollectionModuleManager>
{
	var items: [Target] { get }
	
	required override init(manager: ModuleManager, name: String) {
		
	}
	
	func containsItem(_ target: Target) -> Bool
	func addItem(_ target: Target, ignoreDuplicates: Bool) -> Bool
	func removeItem(_ target: Target) -> Bool
}
