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

    func update(from capability: AACapability) {
        guard capability.command is AAVehicleLocation.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AAVehicleLocation.self) else {
            return
        }

        isAvailable = true
    }
}

extension VehicleLocationClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let vehicleLocation = response as? AAVehicleLocation else {
            return nil
        }

        guard let coordinates = vehicleLocation.coordinates else {
            return nil
        }

        self.coordinates = coordinates

        return .other(self)
    }
}
