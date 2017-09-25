//
//  Rooftop+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getRooftopState(failed: @escaping CommandFailed) {
        let bytes = AutoAPI.RooftopControlCommand.getStateBytes

        print("- Car - get rooftop state")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(dimmed: Bool, failed: @escaping CommandFailed) {
        guard let rooftop = rooftop else {
            return failed(.needsInitialState)
        }

        guard let bytes = AutoAPI.RooftopControlCommand.controlRooftopBytes((dimmed ? 100 : 0), (rooftop.open ? 100 : 0)) else {
            return failed(.invalidValues)
        }

        print("- Car - send rooftop command, dimmed: \(dimmed)")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(open: Bool, failed: @escaping CommandFailed) {
        guard let rooftop = rooftop else {
            return failed(.needsInitialState)
        }

        guard let bytes = AutoAPI.RooftopControlCommand.controlRooftopBytes((rooftop.dimmed ? 100 : 0), (open ? 100 : 0)) else {
            return failed(.invalidValues)
        }

        print("- Car - send rooftop command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
