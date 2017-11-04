//
//  GetScheduleResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct GetScheduleResponse
{
	var days: [GetScheduleResponseDay] = []
}

struct GetScheduleResponseDay
{
	var dayId: String!
	var secondLunch: String!
	var blocks: [GetScheduleResponseBlock] = []
}

struct GetScheduleResponseBlock
{
	var blockId: String!
	var startTime: String!
	var endTime: String!
}
