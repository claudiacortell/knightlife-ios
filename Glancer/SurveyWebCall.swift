//
//  SurveyWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class SurveyWebCall: UnboxWebCall<KnightlifePayload<SurveyPayload>, URL> {
	
	init(version: String) {
		super.init(call: "survey")
		
		self.parameter("version", val: version)
	}
	
	override func convertToken(_ data: KnightlifePayload<SurveyPayload>) -> URL? {
		if let content = data.content {
			if let url = URL(string: content.urlString) {
				return url
			}
		}
		return nil
	}
	
}

class SurveyPayload: WebCallPayload {
	
	let urlString: String
	
	required init(unboxer: Unboxer) throws {
		self.urlString = try unboxer.unbox(key: "url")
	}
	
}
