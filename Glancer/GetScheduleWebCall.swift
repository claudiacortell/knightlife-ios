//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetScheduleWebCall: WebCall<GetScheduleResponse>
{
	init()
	{
		super.init(call: "schedule/template")
		self.token()
	}
	
	func handleData(data: Data) -> GetScheduleResponse?
	{
		if let json = try? JSONSerialization.jsonObject(with: data, options: [])
		{
			if let root = json as? [String: Any]
			{
				if let days = root["days"] as? [Any]
				{
					var response = GetScheduleResponse()
					
					for day in days
					{
						if let dayElements = day as? [String: Any]
						{
							let dayId = dayElements["dayId"] as? String
							let secondLunch = dayElements["secondLunch"] as? String
							
							if dayId != nil && secondLunch != nil
							{
								var dayResponse = GetScheduleResponseDay()
								dayResponse.dayId = dayId
								dayResponse.secondLunch = secondLunch
								
								if let blocks = dayElements["blocks"] as? [Any]
								{
									for block in blocks
									{
										if let blockElements = block as? [String: Any]
										{
											let blockId = blockElements["blockId"] as? String
											let startTime = blockElements["startTime"] as? String
											let endTime = blockElements["endTime"] as? String
											
											if blockId != nil && startTime != nil && endTime != nil
											{
												var blockResponse = GetScheduleResponseBlock()
												
												blockResponse.blockId = blockId
												blockResponse.startTime = startTime
												blockResponse.endTime = endTime
												
												dayResponse.blocks.append(blockResponse)
											}
										}
									}
								}
								
								response.days.append(dayResponse)
							}
						}
					}
					
					return response
				}
			}
		}
		
		return nil
	}
}
