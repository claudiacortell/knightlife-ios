//
//  BadgeTetheredPreferences.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/25/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import RealmSwift

protocol BadgeTethered {
	
	// The unique badge that identifies this object
	var badge: String { get }
	
	// Alias method that fetches the prefs for this object
	var prefs: BadgeTetheredPreferences { get }
	
}

final class BadgeTetheredPreferences: Object {
	
	@objc dynamic var badge: String!
//	@objc dynamic var preferences: [String: Any] = [:]
	
	override static func primaryKey() -> String {
		return "badge"
	}
	
}

extension BadgeTetheredPreferences {
	
	static func get(for: BadgeTethered) -> BadgeTetheredPreferences {
		var preferences = Realms.object(ofType: BadgeTetheredPreferences.self, forPrimaryKey: `for`.badge)
		
		if preferences == nil {
			preferences = BadgeTetheredPreferences()
			preferences!.badge = `for`.badge
			
			Realms.add(preferences!, update: true)
		}
		
		return preferences!
	}
	
}

extension BadgeTetheredPreferences {
	
	subscript<C: Any>(index: String) -> C? {
		get {
			return nil
//			return self.preferences[index] as? C
		}
		
		set(newValue) {
//			self.preferences[index] = newValue
		}
	}
	
}
