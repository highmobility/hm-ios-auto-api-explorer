//
//  TrunkClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getTrunkState(failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunkAccess.getState

        print("- Car - get trunk state")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunkAccess.controlTrunk((lock ? .locked : .unlocked), changePosition: nil)

        print("- Car - send trunk command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(open: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunkAccess.controlTrunk(nil, changePosition: (open ? .open : .closed))

        print("- Car - send trunk command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
