//
//  VehicleStatii+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func getVehicleStatii(failed: @escaping CommandFailed) {
        let bytes = AAVehicleStatus.getVehicleStatus()

        print("- Car - get vehicle statii")

        sendCommand(bytes, failed: failed)
    }
}
