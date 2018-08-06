//
//  PushNotificationManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/5/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class PushNotificationManager: Manager {
	
	static let instance = PushNotificationManager()
	
	private var updateListeners: [String: (Date) -> Void] = [:]
	
	init() {
		super.init("Push Notification")
	}
	
	func handle(payload: [AnyHashable: Any]) {
		guard let dictionary = payload as? [String: Any] else {
			return
		}
		
		guard let typeRaw = dictionary["type"] as? String, let type = PushType(rawValue: typeRaw) else {
			return
		}
		
//		switch type {
//		case .UPDATE:
//
//		}
	}
	
	private func handleUpdate() {
		
	}
	
}

enum PushType: String {
	
	case UPDATE = "update"
	
}

struct PushUpdateData: Unboxable {
	
//	let date: String
	
	init(unboxer: Unboxer) throws {
		
	}
	
}
