//
//  Callback.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/16/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import Signals

typealias CallbackSignal<C> = Signal<Callback<C>>

enum Callback<C> {
	
	case success(_ data: C)
	case failure(_ error: Error)
	
}
