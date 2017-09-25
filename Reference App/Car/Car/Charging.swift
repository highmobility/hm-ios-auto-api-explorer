//
//  Charging.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Charging: Command {

    public typealias Percentage = UInt8


    public private(set) var battery: Percentage = Percentage.max
    public private(set) var charging: Bool = false
}

extension Charging: Parser {

}

extension Charging: Hashable {

    public var hashValue: Int {
        return battery.hashValue + charging.hashValue
    }


    public static func ==(lhs: Charging, rhs: Charging) -> Bool {
        return (lhs.battery == rhs.battery) && (lhs.charging == rhs.charging)
    }
}

extension Charging: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.ChargingCommand.Capability else {
            return
        }

        guard (capability == .available) || (capability == .onlyGetState) else {
            return
        }

        becameAvailable(self)
    }
}

extension Charging: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.ChargingCommand.Response else {
            return nil
        }

        battery = response.batteryLevel
        charging = response.chargingState == .charging

        return .other(self)
    }
}

extension Charging: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.ChargingCommand.VehicleStatus else {
            return
        }

        battery = vehicleStatus.batteryLevel
        charging = vehicleStatus.chargingState == .charging
    }
}
