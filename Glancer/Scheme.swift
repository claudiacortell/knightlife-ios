//
//  Scheme.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

enum Scheme {
	
	case blue
	
	case main
	case backgroundMedium
	case backgroundColor
	
	case darkText
	case text
	case lightText
	
	case nullColor
	
	case hollowText
	
	case dividerColor
	
	var color: UIColor {
		switch self {
		case .blue:
			return UIColor(hex: "4481eb")!
		case .main:
			return UIColor.white
		case .backgroundMedium:
			return UIColor(hex: "F8F8FA")!
		case .backgroundColor:
			return UIColor.groupTableViewBackground
		case .darkText:
			return UIColor.darkText
		case .text:
			return UIColor.darkGray
		case .lightText:
			return UIColor.lightGray
		case .nullColor:
			return UIColor(hex: "848484")!
		case .hollowText:
			return UIColor(hex: "9F9FAA")!
		case .dividerColor:
			return UIColor(hex: "E1E1E6")!
		}
	}
	
}
