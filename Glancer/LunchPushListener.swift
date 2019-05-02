//
//  LunchPushListener.swift
//  Glancer
//
//  Created by Dylan Hanson on 4/29/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation

class LunchPushListener: PushRefreshListener {
	
	var refreshListenerType: [PushRefreshType] = [.LUNCH]
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		Lunch.fetch(for: date).subscribeOnce(with: self) { _ in
			queue.leave()
		}
	}
	
}
