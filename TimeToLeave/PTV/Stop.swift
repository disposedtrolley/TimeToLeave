//
//  Stop.swift
//  TimeToLeave
//
//  Created by James Liu on 20/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Foundation

struct Stop {
    var suburb: String
    var name: String
    var id: Int
    var location: [String:Float?] = [
        "latitude": nil,
        "longitude": nil
    ]
}
