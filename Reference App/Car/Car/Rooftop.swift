//
//  Rooftop.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Rooftop: Command {

    public private(set) var dimmed: Bool = false
    public private(set) var open: Bool = false
}

extension Rooftop: Parser {

}

extension Rooftop: Hashable {

    public var hashValue: Int {
        return dimmed.hashValue + open.hashValue
    }


    public static func ==(lhs: Rooftop, rhs: Rooftop) -> Bool {
        return (lhs.dimmed == rhs.dimmed) && (lhs.open == rhs.open)
    }
}

extension Rooftop: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.RooftopControlCommand.Capability else {
            return
        }

        // Check the values
        guard (capability.dimming == .available) || (capability.dimming == .only0or100) else {
            return
        }

        guard (capability.openClose == .available) || (capability.openClose == .only0or100) else {
            return
        }

        becameAvailable(self)
    }
}

extension Rooftop: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.RooftopControlCommand.Response else {
            return nil
        }

        dimmed = response.dimmingState == 100
        open = response.openState == 100

        return .other(self)
    }
}

extension Rooftop: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.RooftopControlCommand.VehicleStatus else {
            return
        }

        dimmed = vehicleStatus.dimmingState == 100
        open = vehicleStatus.openState == 100
    }
}
