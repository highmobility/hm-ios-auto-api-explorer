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

    func getChargingState(failed: @escaping CommandFailed) {
        guard charging.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AACharging.getChargingState()

        print("- Car - get charging state")

        sendCommand(bytes, failed: failed)
    }

    func sendChargingCommand(start: Bool, failed: @escaping CommandFailed) {
        guard charging.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AACharging.startStopCharging(status: start ? .charging : .notCharging) 

        print("- Car - send charging command, start: \(start)")

        sendCommand(bytes, failed: failed)
    }
}
