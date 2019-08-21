//
//  BlockMetaID.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//



import Foundation

/*creates a BlockMetaID object class.
 there are 7 cases, lunch, activites, etc

 

 BlockMetaID are the ID labels for 'extra' blocks.
    (BlockID is a bigger subset of block labels, has abcdefg lab custom + BlockMetaID)
 
 
variables:
    - values: [BlockMetaID]
        an array of all of the cases
    - displayName: String
 
 functions
    - fromBlockID (block: BlockID) -> BlockMetaID?
        return the corresponding BlockMetaID for block (the BlockID object)
        if it is custom or lab, the BlockMetaID obj returned is nil
        if it is anything other than that (abcdefg), it is returned as free
 
 
 */


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
		.x,
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
