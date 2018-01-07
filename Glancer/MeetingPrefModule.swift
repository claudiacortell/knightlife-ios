//
//  MeetingPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/1/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class MeetingPrefModule: Module<MeetingManager>, PreferenceHandler
{
	var storageKey: String
	{
		return self.nameComplete
	}
	
	func getStorageValues() -> Any?
	{
		return self.manager.meetings
	}
	
	func readStorageValues(data: Any)
	{
		if let list = data as? [Course]
		{
			for meeting in list
			{
				self.manager.addMeeting(meeting)
			}
		}
	}
}
