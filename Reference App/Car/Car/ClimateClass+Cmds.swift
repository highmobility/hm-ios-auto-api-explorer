//
//  ClimateClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func getClimateState(failed: @escaping CommandFailed) {
        guard climate.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAClimate.getClimateState.bytes

        print("- Car - get climate state")

        sendCommand(bytes, failed: failed)
    }

    func sendHVACCommand(activate: Bool, failed: @escaping CommandFailed) {
        guard climate.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAClimate.startStopHVAC(activate ? .active : .inactive).bytes

        print("- Car - send HVAC command, activate: \(activate)")

        sendCommand(bytes, failed: failed)
    }

    func sendWindshieldDefrostingCommand(defrosting: Bool, failed: @escaping CommandFailed) {
        guard climate.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAClimate.startStopDefrosting(defrosting ? .active : .inactive).bytes

        print("- Car - send windshield defrosting command, defrosting: \(defrosting)")

        sendCommand(bytes, failed: failed)
    }
}
