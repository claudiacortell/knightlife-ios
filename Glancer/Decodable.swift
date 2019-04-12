//
//  Decodable.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Decodable {
	
	init(json: JSON) throws

}
