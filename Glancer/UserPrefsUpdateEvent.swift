//
//  UserPrefsUpdateEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/31/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class UserPrefsUpdateEvent: Event
{
	let type: PrefsUpdateType
	
	init(type: PrefsUpdateType)
	{
		self.type = type
		super.init(name: "userprefs.update")
	}
}

enum PrefsUpdateType
{
	case meta, lunch, load
}
