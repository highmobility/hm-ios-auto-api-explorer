//
//  ConnectionState.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


public enum ConnectionState {   // Could be renamed to say bluetooth-something

    case unavailable

    case disconnected

    case idle

    case searching

    case connected

    case authenticated
}
