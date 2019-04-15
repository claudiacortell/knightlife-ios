//
//  BlockMeta.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Signals

class BlockMeta: Object {
	
	// Badge functions as raw BlockMetaID
	@objc dynamic var badge: String = ""
	
	let onUpdate = Signal<Void>()
	
	var id: BlockMeta.ID {
		return BlockMeta.ID(rawValue: self.badge)!
	}
	
	@objc dynamic var _color: String? = nil
	@objc dynamic var _customName: String? = nil
	@objc dynamic var _beforeClassNotifications: Bool = true
	@objc dynamic var _afterClassNotifications: Bool = false

	override static func primaryKey() -> String {
		return "badge"
	}
	
}

extension BlockMeta {
	
	var color: UIColor {
		get {
			return UIColor(hex: self._color ?? "") ?? Scheme.nullColor.color
		}
		
		set {
			try! Realms.write {
				self._color = newValue.toHex!
			}
			
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	var customName: String? {
		get {
			return self._customName
		}
		
		set {
			try! Realms.write {
				self._customName = newValue
			}
			
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	var beforeClassNotifications: Bool {
		get {
			return self._beforeClassNotifications
		}
		
		set {
			try! Realms.write {
				self._beforeClassNotifications = newValue
			}
			
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	var afterClassNotifications: Bool {
		get {
			return self._afterClassNotifications
		}
		
		set {
			try! Realms.write {
				self._afterClassNotifications = newValue
			}
			
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
}
