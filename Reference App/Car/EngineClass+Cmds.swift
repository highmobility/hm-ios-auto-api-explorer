//
//  EngineClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func sendEngineCommand(on: Bool, failed: @escaping CommandFailed) {
        guard engine.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAIgnition.turnIgnitionOnOff(state: on ? .on : .off)

        print("- Car - send engine command, on: \(on)")

        sendCommand(bytes, failed: failed)
    }
}
