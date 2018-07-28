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

struct CustomBlockMeta {
	
	let name: String
	let color: UIColor
	
}

struct Block {
	
	fileprivate let uuid: UUID = UUID()
	
	let id: BlockID
	let variation: Int?

	let time: TimeDuration

	let custom: CustomBlockMeta?
	
}

extension Block: Equatable {
	
	static func ==(lhs: Block, rhs: Block) -> Bool {
		return lhs.uuid == rhs.uuid
	}
	
	var hashValue: Int {
		return self.uuid.hashValue
	}
	
}
