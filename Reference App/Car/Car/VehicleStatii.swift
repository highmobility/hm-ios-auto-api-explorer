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

    let parseStatus: (AACommand) -> Void


    init(parseStatus: @escaping (AACommand) -> Void) {
        self.parseStatus = parseStatus

        super.init()

        isAvailable = true
        isMetaCommand = true
    }
}

extension VehicleStatii: ParserResponseOnly {

}

extension VehicleStatii: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let vehicleStatus = response as? AAVehicleStatus else {
            return nil
        }

        vehicleStatus.states?.compactMap { $0 as? AACommand }.forEach {
            self.parseStatus($0)
        }

        if let powertrain = vehicleStatus.powerTrain {
            switch powertrain {
            case .allElectric:      return .vehicleStatii(powertrain: "electric")
            case .combustionEngine: return .vehicleStatii(powertrain: "ICE")
            case .hydrogen:         return .vehicleStatii(powertrain: "H2")
            case .hydrogenHybrid:   return .vehicleStatii(powertrain: "H2-hybrid")
            case .plugInHybrid:     return .vehicleStatii(powertrain: "plug-in")
            default:                return .vehicleStatii(powertrain: "unknown")
            }
        }
        else {
            return .vehicleStatii(powertrain: "")
        }
    }
}
