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
	
	/**
	https://realm.io/docs/swift/latest/#updating-values
	**/
	
	let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.KnightLife.MAD.Realms")!
	let realmPath = directory.path.appending("/db.realm");
	
	let config = Realm.Configuration(
		fileURL: URL(string: realmPath)!,
		
		// Set the new schema version. This must be greater than the previously used
		// version (if you've never set a schema version before, the version is 0).
		schemaVersion: 0,
		
		// Set the block which will be called automatically when opening a Realm with
		// a schema version lower than the one set above
		migrationBlock: { migration, oldSchemaVersion in
//			// We haven’t migrated anything yet, so oldSchemaVersion == 0
//			if (oldSchemaVersion < 1) {
//				// Nothing to do!
//				// Realm will automatically detect new properties and removed properties
//				// And will update the schema on disk automatically
//			}
	})
	
	// Tell Realm to use this new configuration object for the default Realm
	Realm.Configuration.defaultConfiguration = config
	
	// Now that we've told Realm how to handle the schema change, opening the file
	// will automatically perform the migration
	let realm = try! Realm()
	
	// Get our Realm file's parent directory
	let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
	
	// We disable encryption for the Realm database so that application extensions can access its data
	try! FileManager.default.setAttributes([ FileAttributeKey.protectionKey: FileProtectionType.none ], ofItemAtPath: folderPath)
	
	return realm
	
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
