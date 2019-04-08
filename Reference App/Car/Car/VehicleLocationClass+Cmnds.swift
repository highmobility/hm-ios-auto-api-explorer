//
//  VehicleLocationClass+Cmnds.swift
//  Car
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func getVehicleLocation(failed: @escaping CommandFailed) {
        guard vehicleLocation.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAVehicleLocation.getLocation.bytes

        print("- Car - get vehicle location")

        sendCommand(bytes, failed: failed)
    }
}
