//
//  UIColor+Core.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	
//	https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift
	
	var toHex: String? {
		return toHex()
	}
	
	// MARK: - From UIColor to String
	
	func toHex(alpha: Bool = false) -> String? {
		guard let components = cgColor.components, components.count >= 3 else {
			return nil
		}
		
		let r = Float(components[0])
		let g = Float(components[1])
		let b = Float(components[2])
		var a = Float(1.0)
		
		if components.count >= 4 {
			a = Float(components[3])
		}
		
		if alpha {
			return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
		} else {
			return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
		}
	}
	
}
