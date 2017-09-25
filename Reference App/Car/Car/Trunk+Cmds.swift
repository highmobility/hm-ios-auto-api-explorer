//
//  Trunk+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getTrunkState(failed: @escaping CommandFailed) {
        let bytes = AutoAPI.TrunkAccessCommand.getStateBytes

        print("- Car - get trunk state")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(lock: Bool, failed: @escaping CommandFailed) {
        guard let trunk = trunk else {
            return failed(.needsInitialState)
        }

        let bytes = AutoAPI.TrunkAccessCommand.openTrunkBytes((lock ? .lock : .unlock), (trunk.open ? .open : .close))

        print("- Car - send trunk command, lock: \(lock)")

        sendCommand(bytes, failed: failed)
    }

    public func sendTrunkCommand(open: Bool, failed: @escaping CommandFailed) {
        guard let trunk = trunk else {
            return failed(.needsInitialState)
        }

        let bytes = AutoAPI.TrunkAccessCommand.openTrunkBytes((trunk.locked ? .lock : .unlock), (open ? .open : .close))

        print("- Car - send trunk command, open: \(open)")
        
        sendCommand(bytes, failed: failed)
    }
}
