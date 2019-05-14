//
//  EventPushListener.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/12/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation

class EventPushListener: PushRefreshListener {
	
	var refreshListenerType: [PushRefreshType] = [.EVENTS]
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		DayEventList.fetch(for: date).subscribeOnce(with: self) { _ in
			queue.leave()
		}
	}
	
}
