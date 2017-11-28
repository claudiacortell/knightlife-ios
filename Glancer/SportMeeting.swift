//
//  SportMeeting.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum SportMeetingType
{
	case
	practice,
	game
}

protocol SportMeeting
{
	var type: SportMeetingType { get }
	var team: SportTeam { get }
}

struct PracticeSportMeeting: SportMeeting
{
	let type: SportMeetingType
	let team: SportTeam
	
	let duration: TimeDuration
}

struct GameSportMeeting: SportMeeting
{
	let type: SportMeetingType
	let team: SportTeam
	
	let start: EnscribedTime
	
	let home: Bool?
	let opponent: String?
	let location: String?
	
	let changed: Bool
}
