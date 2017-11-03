//
//  TimeDuration.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct TimeDuration
{
	let startTime: EnscribedTime
	let endTime: EnscribedTime
	
	init(startTime: EnscribedTime, endTime: EnscribedTime)
	{
		self.startTime = startTime
		self.endTime = endTime
	}
}
