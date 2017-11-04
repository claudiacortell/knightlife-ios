//
//  GetPatchesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetPatchesWebCall: WebCall<GetPatchesResponse>
{
	init()
	{
		super.init(call: "schedule/patches")
		self.token()
	}
//	MODIFY THIS SO IT'S A LIST OF PATCHES.
	override func handleData(data: Data) -> GetPatchesResponse?
	{
		if let json = try? JSONSerialization.jsonObject(with: data, options: [])
		{
			if let root = json as? [String: Any]
			{
				let dayId = root["dayId"] as? String
				
				if dayId != nil
				{
					var patchesResponse = GetPatchesResponse()
					patchesResponse.dayId = dayId
					
					if let blocks = root["blocks"] as? [Any]
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
									var blockResponse = GetPatchesResponseBlock()
									
									blockResponse.blockId = blockId
									blockResponse.startTime = startTime
									blockResponse.endTime = endTime
									
									patchesResponse.blocks.append(blockResponse)
								}
							}
						}
					}
					
					return patchesResponse
				}
			}
		}
		
		return nil
	}
}
