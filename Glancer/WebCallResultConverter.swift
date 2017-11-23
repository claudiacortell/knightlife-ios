//
//  WebCallResultConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import Unbox

class WebCallResultConverter<WebCallManager: Manager, DataContainer: WebCallResult, DataResult>
{
	var manager: WebCallManager { return self.webCall.manager }
	var webCall: WebCall<WebCallManager, DataContainer, DataResult>!
	func convert(_ data: DataContainer) -> DataResult? { return nil }
}
