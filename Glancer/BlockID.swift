//
//  BlockID.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

extension Block {
	
	enum ID: String {
		
		case a = "a"
		case b = "b"
		case c = "c"
		case d = "d"
		case e = "e"
		case f = "f"
		case g = "g"
		case x = "x"
		case lunch = "lunch"
		case activities = "activities"
		case lab = "lab"
		case custom = "custom"
		case advisory = "advisory"
		case classMeeting = "class_meeting"
		case assembly = "assembly"
		
		init?(index: Int) {
			let values: [Block.ID] = [.a, .b, .c, .d, .e, .f, .g, .x, .lunch, .activities, .lab, .custom, .advisory, .classMeeting, .assembly]
			if !values.indices.contains(index) {
				return nil
			}
			
			self = values[index]
		}
		
		var shortName: String {
			switch self {
			case .a:
				return "A"
			case .b:
				return "B"
			case .c:
				return "C"
			case .d:
				return "D"
			case .e:
				return "E"
			case .f:
				return "F"
			case .g:
				return "G"
			case .x:
				return "X"
			case .lunch:
				return "Lunch"
			case .activities:
				return "Activities"
			case .lab:
				return "Lab"
			case .custom:
				return "Special"
			case .advisory:
				return "Advisory"
			case .classMeeting:
				return "Class Meeting"
			case .assembly:
				return "Assembly"
			}
		}
		
		var displayName: String {
			if ID.letterBlocks.contains(self) {
				return "\(self.shortName) Block"
			}
			return self.shortName
		}
		
		static var letterBlocks: [ID] { return [.a, .b, .c, .d, .e, .f, .g, .x] }
		static var academicBlocks: [ID] { return [.a, .b, .c, .d, .e, .f, .g] }
		
	}
	
}
