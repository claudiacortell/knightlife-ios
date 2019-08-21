//
//  BlockMeta.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockMeta {
    /*creates a BlockMetaID object.
    
        BlockMetas are what are used under settings under 'Block Configuration'
            aka the extras. activites, x block, assembly, free, class meeting, you get the idea.
        There are courses (abcdefg) and there are the 'extras' which are the BlockMetas
     
     variables
        - block: BlockMetaID
            the ID for the BlockMeta created
        - color: UIColor
        - beforeClassNotifications: Bool
            bool because toggle notifications in settings
        - afterClassNotifications: Bool
            ^^^^
        - customName: String?
            so I'm pretty sure this is 'String?' because only 'free' out of the BlockMetas gives an option for a custom name in settings.
     
    has an init (constructor method) to create a BlockMeta object
        - most of the parameters are nil except the blockMetaID
        - sets self.variable = parameter for pretty much all variables EXCEPT the before/afterClassNotifications.
        - it automatically turns on before class notifications and turns off after class notifications. I mean think about it, the default notifications you see on your phone are '5 minutes until English' or something like that.
    
	*/
	let block: BlockMetaID
	
	var color: UIColor
	var beforeClassNotifications: Bool
	var afterClassNotifications: Bool
	
	var customName: String?
	
	init(block: BlockMetaID, color: UIColor? = nil, beforeClassNotifications: Bool? = nil, afterClassNotifications: Bool? = nil, customName: String? = nil) {
		self.block = block
		
		self.color = color ?? Scheme.nullColor.color
		
		self.beforeClassNotifications = beforeClassNotifications ?? true
		self.afterClassNotifications = afterClassNotifications ?? false
		
		self.customName = customName
	}
	
}

