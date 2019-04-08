//
//  ParkingBrakeCommand+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func sendParkingBrake(activate: Bool, failed: @escaping CommandFailed) {
        guard parkingBrake.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAParkingBrake.activate(activate ? .active : .inactive).bytes

        print("- Car - send parking brake, activate: \(activate)")

        sendCommand(bytes, failed: failed)
    }
}
