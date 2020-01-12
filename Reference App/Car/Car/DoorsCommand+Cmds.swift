//
//  DoorsCommand+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func getDoorsState(failed: @escaping CommandFailed) {
        guard doors.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AADoors.getDoorsState()

        print("- Car - get doors state")

        sendCommand(bytes, failed: failed)
    }

    func sendDoorsCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard doors.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AADoors.lockUnlockDoors(locksState: lock ? .locked: .unlocked)

        print("- Car - send doors command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }
}
