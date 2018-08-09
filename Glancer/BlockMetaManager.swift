//
//  BlockMetaManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//
//  This is a super simple class that retrieves a BlockMeta object and saves it when you want.
//

import Foundation
import AddictiveLib
import UIKit

class BlockMetaManager: Manager {
	
	static let instance = BlockMetaManager()
	
	private(set) var meta: [BlockMetaID: BlockMeta] = [:]
	
	init() {
		super.init("Block Meta")
		
		self.registerStorage(BlockMetaStorage(manager: self))
	}
	
	func loadedMeta(meta: BlockMeta) {
		self.meta[meta.block] = meta
	}
	
	func getBlockMeta(id: BlockID) -> BlockMeta? {
		guard let metaId = BlockMetaID.fromBlockID(block: id) else {
			return nil
		}
		
		return self.getBlockMeta(metaId: metaId)
	}
	
	func getBlockMeta(metaId: BlockMetaID) -> BlockMeta {
		if self.meta[metaId] == nil {
			self.meta[metaId] = BlockMeta(block: metaId)
			self.saveStorage()
		}
		
		return self.meta[metaId]!
	}
	
}
