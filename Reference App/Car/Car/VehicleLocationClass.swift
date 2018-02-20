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

    public private(set) var coordinate = CLLocationCoordinate2D()
}

extension VehicleLocationClass: Parser {


}

extension VehicleLocationClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is VehicleLocation.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: VehicleLocation.self) else {
            return
        }

        isAvailable = true
    }
}

extension VehicleLocationClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let vehicleLocation = response as? VehicleLocation else {
            return nil
        }

        guard let coordinates = vehicleLocation.coordinate else {
            return nil
        }

        self.coordinate = coordinates

        return .other(self)
    }
}
