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
	
	case defaultGray
	
	var color: UIColor {
		switch self {
		case .blue:
			return UIColor(hex: "5794DC")!
		case .defaultGray:
			return UIColor(hex: "21262b")!
		}
	}
	
}
