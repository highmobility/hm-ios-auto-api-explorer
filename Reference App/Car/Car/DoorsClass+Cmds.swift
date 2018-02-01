//
//  DoorsClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getDoorsState(failed: @escaping CommandFailed) {
        guard doors.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = DoorLocks.getLockState

        print("- Car - get doors state")

        sendCommand(bytes, failed: failed)
    }

    public func sendDoorsCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard doors.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = DoorLocks.lockUnlock(lock ? .lock: .unlock)

        print("- Car - send doors command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }
}
