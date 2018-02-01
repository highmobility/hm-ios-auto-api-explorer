//
//  VehicleStatii.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


class VehicleStatii: CommandClass {

    let parseVehicleStatus: (VehicleState) -> Void


    init(parseVehicleStatus: @escaping (VehicleState) -> Void) {
        self.parseVehicleStatus = parseVehicleStatus

        super.init()

        isAvailable = true
        isMetaCommand = true
    }
}

extension VehicleStatii: ParserResponseOnly {

}

extension VehicleStatii: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let vehicleStatus = response as? VehicleStatus else {
            return nil
        }

        vehicleStatus.states?.forEach {
            self.parseVehicleStatus($0)
        }

        return .vehicleStatii
    }
}
