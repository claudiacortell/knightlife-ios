//
//  BlockMeta.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/31/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct BlockMeta
{
	init(_ blockId: BlockID, _ customColor: String) { self.blockId = blockId; self.customColor = customColor }
	var blockId: BlockID! // E.G. A, B, C, D, E (Corresponds to Class ID)
	var customName: String?// Same as block id by default. Can be changed to reflect user preferences
	var customColor: String!
	var roomNumber: String?
}
