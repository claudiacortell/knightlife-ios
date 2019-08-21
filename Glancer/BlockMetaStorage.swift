//
//  BlockMetaStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

/* Inherits from StorageHandler, which is a Pod. Corresponds with the Manager subclass (BlockMetaManager). the Manager subclass saves it, and the changes get saved to here
 
 */
class BlockMetaStorage: StorageHandler {
	
	var storageKey: String = "blockmeta.items"
	
	let manager: BlockMetaManager
	
	init(manager: BlockMetaManager) {
		self.manager = manager
	}
	
    //saves the data into storage 
    //not sure exactly how it works but thats ok
	func saveData() -> Any? {
		var data: [[String: Any]] = []
		
		for meta in self.manager.meta.values {
			var metaData: [String: Any] = [:]
			
			metaData["block"] = meta.block.rawValue
			metaData["color"] = meta.color.toHex
			
			metaData["notifications"] = meta.beforeClassNotifications
			metaData["notifications_after"] = meta.afterClassNotifications
			
			metaData["name"] = meta.customName
			
			data.append(metaData)
		}
		
		return data
	}
	
	
    
    func loadData(data: Any) {
		guard let data = data as? [[String: Any]] else {
			return
		}
		
		for item in data {
			guard let rawBlock = item["block"] as? Int, let block = BlockMetaID(rawValue: rawBlock) else {
				print("Invalid Block Meta ID")
				continue
			}
			
			guard let rawColor = item["color"] as? String, let color = UIColor(hex: rawColor) else {
				print("Invalid Block Meta Color")
				continue
			}
			
			guard let beforeClassNotifications = item["notifications"] as? Bool else {
				print("Invalid Block Meta notifications flag")
				continue
			}
			
			let afterClassNotifications: Bool? = item["notifications_after"] as? Bool
			
			var name: String?
			if block == .free {
				if let rawName = item["name"] as? String {
					name = rawName
				}
			}
			
			let meta = BlockMeta(block: block, color: color, beforeClassNotifications: beforeClassNotifications, afterClassNotifications: afterClassNotifications, customName: name)
			self.manager.loadedMeta(meta: meta)
			
			print("Successfully loaded Block Meta: \(meta.block.displayName)")
		}
	}
	
	func loadDefaults() {
		
	}
	
}
