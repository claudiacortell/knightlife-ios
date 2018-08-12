//
//  PushRefreshListener.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

protocol PushRefreshListener: PushListener {
	
	var refreshListenerType: [PushRefreshType] { get }
	
	func doListenerRefresh(date: Date)
	
}

enum PushRefreshType: String {
	
	case SCHEDULE = "schedule"
	case EVENTS = "events"
	case LUNCH = "lunch"
	
}
