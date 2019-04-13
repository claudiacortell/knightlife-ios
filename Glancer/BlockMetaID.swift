//
//  BlockMetaID.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

extension BlockMeta {
	
	enum ID: String {
		
		case lunch
		case activities
		case advisory
		case classMeeting
		case assembly
		case x
		
		case free
		
	}
	
}

extension BlockMeta.ID {
	
	var displayName: String {
		switch self {
		case .lunch:
			return "Lunch"
		case .x:
			return "X Block"
		case .activities:
			return "Activities"
		case .advisory:
			return "Advisory"
		case .classMeeting:
			return "Class Meeting"
		case .assembly:
			return "Assembly"
		case .free:
			return "Free Blocks"
		}
	}
	
}

extension BlockMeta.ID {
	
	static var values: [BlockMeta.ID] = [
		.lunch,
		.activities,
		.advisory,
		.classMeeting,
		.assembly,
		.x,
		.free]
	
}

extension BlockMeta.ID {
	
	init?(id: BlockID) {
		
		switch id {
		case .lab:
			return nil
		case .custom:
			return nil
		case .x:
			self = .x
		case .lunch:
			self = .lunch
		case .activities:
			self = .activities
		case .advisory:
			self = .advisory
		case .classMeeting:
			self = .classMeeting
		case .assembly:
			self = .assembly
		default:
			self = .free
		}
		
	}
	
}
