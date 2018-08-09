//
//  BlockMetaStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class BlockMetaStorage: StorageHandler {
	
	var storageKey: String = "blockmeta.items"
	
	let manager: BlockMetaManager
	
	init(manager: BlockMetaManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		var data: [[String: Any]] = []
		
		for meta in self.manager.meta.values {
			var metaData: [String: Any] = [:]
			
			metaData["block"] = meta.block.rawValue
			metaData["color"] = meta.color.toHex
			
			metaData["notifications"] = meta.notifications
			
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
			
			guard let notifications = item["notifications"] as? Bool else {
				print("Invalid Block Meta notifications flag")
				continue
			}
			
			let meta = BlockMeta(block: block, color: color, notifications: notifications)
			self.manager.loadedMeta(meta: meta)
			
			print("Successfully loaded Block Meta: \(meta.block.displayName)")
		}
	}
	
	func loadDefaults() {
		
	}
	
}
