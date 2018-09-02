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

enum PushType: String {
	
	case REFRESH = "refresh"
	
}

protocol PushListener {
	
}

class PushNotificationManager: Manager {
	
	static let instance = PushNotificationManager()
	
	private(set) var listeners: [PushType: [PushListener]] = [:]
	
	init() {
		super.init("Push Notification")
	}
	
	func addListener(type: PushType, listener: PushListener) {
		if self.listeners[type] == nil {
			self.listeners[type] = []
		}
		
		self.listeners[type]!.append(listener)
	}
	
	func handle(payload: [AnyHashable: Any], queue: DispatchGroup) {
		guard let dictionary = payload as? [String: Any] else {
			return
		}
		
		guard let typeRaw = dictionary["type"] as? String, let type = PushType(rawValue: typeRaw) else {
			return
		}
		
		guard let data = dictionary["data"] as? [String: Any] else {
			return
		}
		
//		I'm doing this manually per type because there's only one ATM. This should all be abstracted in the future.
		if type == .REFRESH {
			let unboxer = Unboxer(dictionary: data)
			do {
				let token = try PushUnboxRefresh(unboxer: unboxer)
				
				self.getListeners(pushType: type)
					.filter({ $0 is PushRefreshListener }) // Only get the listeners that are PushRefreshListeners i.e. the only ones capable of handling the call
					.map({ $0 as! PushRefreshListener })
					.filter({ $0.refreshListenerType.contains(token.target) })
					.forEach({ $0.doListenerRefresh(date: token.date, queue: queue) })
			} catch {
				print("Invalid data for Refresh request.")
			}
		}
	}
	
	private func getListeners(pushType: PushType) -> [PushListener] {
		if self.listeners[pushType] == nil {
			self.listeners[pushType] = []
		}
		return self.listeners[pushType]!
	}
	
}

