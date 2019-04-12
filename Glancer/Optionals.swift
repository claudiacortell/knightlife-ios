//
//  Optionals.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/20/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation

class Optionals {
	
	static func unwrap<C>(_ value: C?) throws -> C {
		if (value == nil) {
			throw OptionalUnwrapError()
		} else {
			return value!
		}
	}
	
	class OptionalUnwrapError: Error {
		
		var localizedDescription: String {
			return "Attempted to forcefully unwrap a nil value."
		}
		
	}
	
}
