//
//  ChargingClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getChargingState(failed: @escaping CommandFailed) {
        guard charging.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AACharging.getChargingState.bytes

        print("- Car - get charging state")

        sendCommand(bytes, failed: failed)
    }

    public func sendChargingCommand(start: Bool, failed: @escaping CommandFailed) {
        guard charging.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AACharging.startStopCharging(start ? .active : .inactive).bytes

        print("- Car - send charging command, start: \(start)")

        sendCommand(bytes, failed: failed)
    }
}
