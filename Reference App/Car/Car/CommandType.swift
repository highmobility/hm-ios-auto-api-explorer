//
//  CommandType.swift
//  Car
//
//  Created by Mikk Rätsep on 10/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public enum CommandType {

    case capabilities
    case vehicleStatii

    case failureMessage(FailureMessage)
    case other(Command)
}
