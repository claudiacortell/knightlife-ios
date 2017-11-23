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
	static func getHexFromCGColor(_ color: CGColor) -> String
	{
		let components = color.components
		let r: CGFloat = components![0]
		let g: CGFloat = components![1]
		let b: CGFloat = components![2]
		
		let hexString: NSString = NSString(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
		
		return hexString as String
	}
	
	static func getRGBFromHex(_ hex: String) -> [CGFloat]
	{
		let cString:String = hex.trimmingCharacters(in: .whitespaces).uppercased()
		
		let rString = cString.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		let gString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		let bString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 4)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		
		var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
		
		Scanner(string: rString).scanHexInt32(&r)
		Scanner(string: gString).scanHexInt32(&g)
		Scanner(string: bString).scanHexInt32(&b)
		
		let redFloat: CGFloat = CGFloat(r)
		let greenFloat: CGFloat = CGFloat(g)
		let blueFloat:CGFloat = CGFloat(b)
		
		var values: [CGFloat] = [CGFloat]()
		
		values.append(redFloat)
		values.append(greenFloat)
		values.append(blueFloat)
		
		return values
	}
	
	static func getUIColorFromHex (_ hex: String) -> UIColor
	{
		let cString = Utils.substring(hex, start: 0, distance: 6)
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	static func substring(_ string: String, start: Int, distance: Int) -> String
	{
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(startIndex, offsetBy: distance)
        
        return String(string[startIndex..<endIndex])
	}
}
