//
//  Block.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

struct Block {
	
	fileprivate let uuid: UUID = UUID()
	
	let id: BlockID
	
	let time: TimeDuration
	let variation: Int?

	let customName: String? // Only used when the block ID is Custom
	let color: UIColor?
	
}

extension Block: Equatable {
	
	static func ==(lhs: Block, rhs: Block) -> Bool {
		return lhs.uuid == rhs.uuid
	}
	
	var hashValue: Int {
		return self.uuid.hashValue
	}
	
}
