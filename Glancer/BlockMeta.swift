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
	var notifications: Bool
	
	init(block: BlockMetaID, color: UIColor? = nil, notifications: Bool? = nil) {
		self.block = block
		
		self.color = color ?? Scheme.nullColor.color
		self.notifications = notifications ?? true
	}
	
}

