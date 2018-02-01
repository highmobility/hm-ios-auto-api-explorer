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

        let bytes = TrunkAccess.getTrunkState

        print("- Car - get trunk state")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let settings = TrunkAccess.Settings(lock: (lock ? .lock : .unlock), position: nil)
        let bytes = TrunkAccess.openClose(settings)

        print("- Car - send trunk command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(open: Bool, failed: @escaping CommandFailed) {
        guard trunk.isAvailable else {
            return failed(.needsInitialState)
        }

        let settings = TrunkAccess.Settings(lock: nil, position: (open ? .open : .close))
        let bytes = TrunkAccess.openClose(settings)

        print("- Car - send trunk command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
