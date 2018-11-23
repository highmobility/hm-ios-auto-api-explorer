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

        let bytes = AARooftopControl.getRooftopState

        print("- Car - get rooftop state")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(dimmed: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AARooftopControl.controlRooftop(dimming: (dimmed ? 100 : 0), open: nil, convertibleRoof: nil, sunroofTilt: nil)

        print("- Car - send rooftop command, dimmed: \(dimmed)")

        sendCommand(bytes, failed: failed)
    }

    public func sendRooftopCommand(open: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AARooftopControl.controlRooftop(dimming: nil, open: (open ? 100 : 0), convertibleRoof: nil, sunroofTilt: nil)

        print("- Car - send rooftop command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
