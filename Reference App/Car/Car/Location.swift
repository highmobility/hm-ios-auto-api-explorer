//
//  Location.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public enum Location {
    case all
    case frontLeft
    case frontRight
    case hatch
    case rearLeft
    case rearRight


    var stringValue: String {
        switch self {
        case .all:          return "all"
        case .frontLeft:    return "front left"
        case .frontRight:   return "front right"
        case .hatch:        return "hatch"
        case .rearLeft:     return "rear left"
        case .rearRight:    return "rear right"
        }
    }


    init(position: AALocation) {
        switch position {
        case .all:          self = .all
        case .frontLeft:    self = .frontLeft
        case .frontRight:   self = .frontRight
        case .hatch:        self = .hatch
        case .rearLeft:     self = .rearLeft
        case .rearRight:    self = .rearRight
        @unknown default:   fatalError()
        }
    }
}
