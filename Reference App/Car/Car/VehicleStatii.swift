//
//  VehicleStatii.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


class VehicleStatii {

    let parseVehicleStatus: (VehicleStatus) -> Void


    init(parseVehicleStatus: @escaping (VehicleStatus) -> Void) {
        self.parseVehicleStatus = parseVehicleStatus
    }
}

extension VehicleStatii: ParserResponseOnly {

}

extension VehicleStatii: HashableEmpty {

}

extension VehicleStatii: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.VehicleStatusCommand.Response else {
            return nil
        }

        response.vehicleStatuses.forEach {
            self.parseVehicleStatus($0)
        }

        return .vehicleStatii
    }
}
