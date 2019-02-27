//
//  VehicleLocationClass.swift
//  Car
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import CoreLocation
import Foundation


public class VehicleLocationClass: CommandClass {

    public private(set) var coordinates = CLLocationCoordinate2D()
}

extension VehicleLocationClass: Parser {


}

extension VehicleLocationClass: CapabilityParser {

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AAVehicleLocation.Type,
            capability.supportsAllMessageTypes(for: AAVehicleLocation.self) else {
                return
        }

        isAvailable = true
    }
}

extension VehicleLocationClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let vehicleLocation = response as? AAVehicleLocation,
            let coordinates = vehicleLocation.coordinates?.value else {
                return nil
        }

        self.coordinates = coordinates

        return .other(self)
    }
}
