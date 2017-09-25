//
//  Capabilities+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getCapabilities(failed: @escaping CommandFailed) {
        let bytes = AutoAPI.CapabilitiesCommand.getAllCapabilitiesBytes

        // TODO: Should wipe the car clean as well then?

        print("- Car - get capabilities")

        sendCommand(bytes, failed: failed)
    }
}
