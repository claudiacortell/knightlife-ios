//
//  Utils.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Utils
{
	static func substring(_ string: String, start: Int, distance: Int) -> String
	{
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(startIndex, offsetBy: distance)
        
        return String(string[startIndex..<endIndex])
	}
}
