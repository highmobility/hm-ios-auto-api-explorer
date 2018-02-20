//
//  Position+Extensions.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


extension Position {

    var stringValue: String {
        switch self {
        case .frontLeft:    return "front left"
        case .frontRight:   return "front right"
        case .hatch:        return "hatch"
        case .rearLeft:     return "rear left"
        case .rearRight:    return "rear right"
        }
    }
}
