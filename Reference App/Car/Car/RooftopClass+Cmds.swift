//
//  RooftopClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getRooftopState(failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RooftopControl.getRooftopState

        print("- Car - get rooftop state")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(dimmed: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RooftopControl.controlRooftop(.init(dimming: (dimmed ? 100 : 0), openClose: nil))

        print("- Car - send rooftop command, dimmed: \(dimmed)")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(open: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RooftopControl.controlRooftop(.init(dimming: nil, openClose: (open ? 100 : 0)))

        print("- Car - send rooftop command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
