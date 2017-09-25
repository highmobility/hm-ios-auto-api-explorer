//
//  CommandError.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


public enum CommandError: Error {

    case invalidValues
    case needsInitialState

    case miscellaneous(Error)
    case missing(Missing)
    case telematicsFailure(String)

    public enum Missing {
        case authenticatedLink
        case vehicleSerial
    }
}
