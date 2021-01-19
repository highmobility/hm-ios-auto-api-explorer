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

    func getTrunkState(failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunk.getTrunkState()

        print("- Car - get trunk state")

        sendCommand(bytes, failed: failed)
    }

    func sendTrunkCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunk.controlTrunk(lock: (lock ? .locked : .unlocked), position: nil)

        print("- Car - send trunk command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }

    func sendTrunkCommand(open: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AATrunk.controlTrunk(position: (open ? .open : .closed))

        print("- Car - send trunk command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
