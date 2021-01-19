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

    let parseStatus: (AACapability) -> Void


    init(parseStatus: @escaping (AACapability) -> Void) {
        self.parseStatus = parseStatus

        super.init()

        isAvailable = true
        isMetaCommand = true
    }
}

extension VehicleStatii: ParserResponseOnly {

}

extension VehicleStatii: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let vehicleStatus = response as? AAVehicleStatus else {
            return nil
        }

        vehicleStatus.states?.compactMap {
            $0.value
        }.compactMap {
            try? AAAutoAPI.parseBytes($0)
        }.forEach {
            self.parseStatus($0)
        }

        // TODO: powertrain information is in VehicleInformation since L12
        return .vehicleStatii(powertrain: "unknown")
    }
}
