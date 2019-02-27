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

        vehicleStatus.states?.compactMap { $0 }.forEach {
            self.parseStatus($0)
        }

        if let powertrain = vehicleStatus.powerTrain?.value {
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
