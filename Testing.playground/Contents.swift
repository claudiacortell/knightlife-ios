//: Playground - noun: a place where people can play

import UIKit

let now = Date()
let calendar = Calendar.current

let year = calendar.component(.year, from: now)
let month = calendar.component(.month, from: now)
let day = calendar.component(.day, from: now)

print(year, month, day)
