//
//  Label.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/29/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import Foundation

struct Label
{
    var blockLetter: String = ""
    var className: String = ""
    var classTimes: String = ""
	var roomNumber: String = ""
    var color: String = ""
	
	var block: Block?
    
	init(bL: String, cN: String, cT: String, c: String, rN: String, block: Block? = nil)
	{
        blockLetter = bL
        className = cN
        classTimes = cT
        color = c
		self.roomNumber = rN
		
		self.block = block
    }
}
