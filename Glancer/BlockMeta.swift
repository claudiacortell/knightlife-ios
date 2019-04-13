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
	
	@objc dynamic var colorString: String? = nil {
		didSet {
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	@objc dynamic var customName: String? = nil {
		didSet {
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	@objc dynamic var beforeClassNotifications: Bool = true {
		didSet {
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	@objc dynamic var afterClassNotifications: Bool = false {
		didSet {
			self.onUpdate.fire()
			BlockMetaM.onMetaUpdate.fire(self)
		}
	}
	
	override static func primaryKey() -> String {
		return "badge"
	}
	
}

extension BlockMeta {
	
	var color: UIColor {
		get {
			return UIColor(hex: self.colorString ?? "") ?? Scheme.nullColor.color
		}
		
		set {
			self.colorString = newValue.toHex!
		}
	}
	
}
