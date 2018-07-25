//
//  Event.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct Event {
	
	let blockId: BlockID
	let mandatory: Bool
	let audience: [EventAudience]
	
	let description: String
	
}
