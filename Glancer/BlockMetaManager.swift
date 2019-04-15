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
import Signals
import SwiftyUserDefaults

private(set) var BlockMetaM = BlockMetaManager()

extension DefaultsKeys {
	
	fileprivate static let blockMetaMigratedToRealm = DefaultsKey<Bool>("migrated.blockmeta")
	
}

class BlockMetaManager {
	
	let onMetaUpdate = Signal<BlockMeta>()
	
	fileprivate init() {

	}
	
	func loadLegacyData() {
		if !Defaults[.blockMetaMigratedToRealm] {
			let oldStorage = BlockMetaStorage(manager: self)
			StorageHub.instance.loadPrefs(oldStorage)
			
			Defaults[.blockMetaMigratedToRealm] = true
		}
	}
	
	func loadLegacyMeta(meta: BlockMeta) {
		try! Realms.write {
			Realms.add(meta, update: true)
		}
		
		print("Loaded legacy block meta for \( meta.badge )")
	}
	
	func getBlockMeta(block: Block.ID) -> BlockMeta? {
		if let metaId = BlockMeta.ID(id: block) {
			return self.getBlockMeta(meta: metaId)
		}
		return nil
	}
	
	func getBlockMeta(meta: BlockMeta.ID) -> BlockMeta {
		let realm = Realms
		
		var object = realm.object(ofType: BlockMeta.self, forPrimaryKey: meta.rawValue)
		
		if object == nil {
			object = BlockMeta()
			object!.badge = meta.rawValue
			
			try! realm.write {
				realm.add(object!, update: true)
			}
		}
		
		return object!
	}
	
}
