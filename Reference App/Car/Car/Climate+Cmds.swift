//
//  Climate+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getClimateState(failed: @escaping CommandFailed) {
        let bytes = AutoAPI.ClimateCommand.getStateBytes

        print("- Car - get climate state")

        sendCommand(bytes, failed: failed)
    }

    public func sendWindshieldDefrostingCommand(defrosting: Bool, failed: @escaping CommandFailed) {
        let bytes = AutoAPI.ClimateCommand.startStopDefrostingBytes(defrosting ? .activate : .inactivate)

        print("- Car - send windshield defrosting command, defrosting: \(defrosting)")

        sendCommand(bytes, failed: failed)
    }
}
