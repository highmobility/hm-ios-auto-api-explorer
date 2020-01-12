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

    func getRooftopState(failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AARooftopControl.getRooftopState()

        print("- Car - get rooftop state")

        sendCommand(bytes, failed: failed)
    }

    func sendRooftopCommand(dimmed: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        guard let bytes = AARooftopControl.controlRooftop(dimming: dimmed ? 1.0 : 0.0,
                                                          position: nil,
                                                          convertibleRoofState: nil,
                                                          sunroofTiltState: nil,
                                                          sunroofState: nil) else {
                                                            return failed(.invalidValues)
        }

        print("- Car - send rooftop command, dimmed: \(dimmed)")

        sendCommand(bytes, failed: failed)
    }

    func sendRooftopCommand(open: Bool, failed: @escaping CommandFailed) {
        guard rooftop.isAvailable else {
            return failed(.needsInitialState)
        }

        guard let bytes = AARooftopControl.controlRooftop(dimming: nil,
                                                          position: open ? 1.0 : 0.0,
                                                          convertibleRoofState: nil,
                                                          sunroofTiltState: nil,
                                                          sunroofState: nil) else {
                                                            return failed(.invalidValues)
        }

        print("- Car - send rooftop command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
