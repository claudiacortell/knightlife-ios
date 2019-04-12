//
//  Realm+KL.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/30/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import RealmSwift

var Realms: Realm {
	
	return try! Realm()
	
}

//extension Realm {
//
//	static var newInstance: Realm {
//
//		// Move all Realm creation to one method so we can unlock filesystem later if needed
//
//		let realm = try! Realm()
//		return realm
//
//	}
//
//}
