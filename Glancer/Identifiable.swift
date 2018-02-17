//
//  Identifiable.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class Identifiable: Equatable
{
	var ID = UUID()
	
	static func ==(lhs: Identifiable, rhs: Identifiable) -> Bool
	{
		return lhs.ID == rhs.ID;
	}
}
