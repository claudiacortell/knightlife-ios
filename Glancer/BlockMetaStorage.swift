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
//		var data: [[String: Any]] = []
//
//		for meta in self.manager.meta.values {
//			var metaData: [String: Any] = [:]
//
//			metaData["block"] = meta.block.rawValue
//			metaData["color"] = meta.color.toHex
//
//			metaData["notifications"] = meta.beforeClassNotifications
//			metaData["notifications_after"] = meta.afterClassNotifications
//
//			metaData["name"] = meta.customName
//
//			data.append(metaData)
//		}
//
//		return data
		return nil
	}
	
	func loadData(data: Any) {
		guard let data = data as? [[String: Any]] else {
			return
		}
		
		for item in data {
			guard let rawBlock = item["block"] as? Int else {
				print("Invalid Block Meta ID")
				continue
			}
			
			let block = BlockMeta.ID.values[rawBlock]
			
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
			
			let meta = BlockMeta()
			
			meta.badge = block.rawValue
			meta._color = color.toHex!
			meta._beforeClassNotifications = beforeClassNotifications
			meta._afterClassNotifications = afterClassNotifications ?? false
			meta._customName = name
			
			self.manager.loadLegacyMeta(meta: meta)
		}
	}
	
	func loadDefaults() {
		
	}
	
}
