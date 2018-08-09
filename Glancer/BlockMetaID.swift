//
//  BlockMetaID.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

enum BlockMetaID: Int {
	
	case lunch
	case activities
	case advisory
	case classMeeting
	case assembly
	case x
	
	case free
	
	static var values: [BlockMetaID] = [
		.free,
		x,
		.lunch,
		.activities,
		.advisory,
		.classMeeting,
		.assembly]

	static func fromBlockID(block: BlockID) -> BlockMetaID? {
		switch block {
		case .lab:
			return nil
		case .custom:
			return nil
		case .x:
			return .x
		case .lunch:
			return .lunch
		case .activities:
			return .activities
		case .advisory:
			return .advisory
		case .classMeeting:
			return .classMeeting
		case .assembly:
			return .assembly
		default:
			return .free
		}
	}
	
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
