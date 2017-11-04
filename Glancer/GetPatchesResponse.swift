//
//  GetPatchesResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct GetPatchesResponse
{
	var dayId: String!
	var blocks: [GetPatchesResponseBlock] = []
}

struct GetPatchesResponseBlock
{
	var blockId: String!
	var startTime: String!
	var endTime: String!
}
