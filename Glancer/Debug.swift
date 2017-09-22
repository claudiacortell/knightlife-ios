//
//  Debug.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/21/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class Debug
{
	static let debug: Bool = true
	
	static func out(_ msg: String)
	{
		if Debug.debug
		{
			print(msg)
		}
	}
}
