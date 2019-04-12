//
//  UserDefaults+KL.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/30/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// Alias User defaults to our suite
let Defaults = UserDefaults(suiteName: "group.KnightLife.MAD.Storage")!

extension DefaultsKeys {
	
	static let migratedToRealm = DefaultsKey<Bool>("migratedToRealm")
	
	static let deviceId = DefaultsKey<String>("deviceId")
	
	static let userGrade = DefaultsKey<Int?>("userGrade")
	
}
