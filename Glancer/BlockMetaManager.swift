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

/*BlockMetaManager inherits from Manager class
    Manager is a Pod (from AdditiveLib? idk but that doesn't really matter)
    It pretty much allows things to be stored into a corresponding StorageManager subclass, and for things to keep stored values when you shut off the app. not 100% sure but I THINK that might be it
 
*/
class BlockMetaManager: Manager {
	
	static let instance = BlockMetaManager()
	
	private(set) var meta: [BlockMetaID: BlockMeta] = [:]
	let metaUpdatedWatcher = ResourceWatcher<BlockMeta>()
	
	init() {
		super.init("Block Meta")
		
		self.registerStorage(BlockMetaStorage(manager: self))
	}
	
	func loadedMeta(meta: BlockMeta) {
		self.meta[meta.block] = meta
	}
	
    //saves the meta when changed in settings
	func metaChanged(meta: BlockMeta) {
		self.metaUpdatedWatcher.handle(nil, meta)
		self.saveStorage()
	}
	
    
    //the following two methods just return the BlockMeta. i dont know when they're used yet.
    
    //gets BlockMeta (maybe) from BlockID. remember, BlockID is to BlockMeta as rectangles are to squares.
	func getBlockMeta(id: BlockID) -> BlockMeta? {
		guard let metaId = BlockMetaID.fromBlockID(block: id) else {
			return nil
		}
		
		return self.getBlockMeta(metaId: metaId)
	}
	
    //gets the BlockMeta from the BlockMetaID
	func getBlockMeta(metaId: BlockMetaID) -> BlockMeta {
		if self.meta[metaId] == nil {
			self.meta[metaId] = BlockMeta(block: metaId)
			self.saveStorage()
		}
		
		return self.meta[metaId]!
	}
	
}
