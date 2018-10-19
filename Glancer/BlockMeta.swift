//
//  BlockMeta.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockMeta {
	
	let block: BlockMetaID
	
	var color: UIColor
	var beforeClassNotifications: Bool
	var afterClassNotifications: Bool
	
	var customName: String?
	
	init(block: BlockMetaID, color: UIColor? = nil, beforeClassNotifications: Bool? = nil, afterClassNotifications: Bool? = nil, customName: String? = nil) {
		self.block = block
		
		self.color = color ?? Scheme.nullColor.color
		
		self.beforeClassNotifications = beforeClassNotifications ?? true
		self.afterClassNotifications = afterClassNotifications ?? false
		
		self.customName = customName
	}
	
}

