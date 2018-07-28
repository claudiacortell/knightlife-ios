//
//  CompositeBlock.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

struct CompositeBlock {
	
	let schedule: DateSchedule
	let block: Block
	
	let lunch: LunchMenu?
	let events: [Event]
	
}
