//
//  Climate.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Climate: Command {

    public private(set) var windshieldDefrosting: Bool = false
}

extension Climate: Parser {

}

extension Climate: Hashable {

    public var hashValue: Int {
        return windshieldDefrosting.hashValue
    }


    public static func ==(lhs: Climate, rhs: Climate) -> Bool {
        return lhs.windshieldDefrosting == rhs.windshieldDefrosting
    }
}

extension Climate: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.ClimateCommand.Capability else {
            return
        }

        guard capability.climate == .available else {
            return
        }

        becameAvailable(self)
    }
}

extension Climate: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.ClimateCommand.Response else {
            return nil
        }

        windshieldDefrosting = response.defrostingState == .activated

        return .other(self)
    }
}

extension Climate: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.ClimateCommand.VehicleStatus else {
            return
        }

        windshieldDefrosting = vehicleStatus.defrostingState == .activated
    }
}
