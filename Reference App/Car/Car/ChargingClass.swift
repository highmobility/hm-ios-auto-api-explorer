//
//  ChargingClass.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class ChargingClass: CommandClass {

    public typealias Percentage = UInt8


    public private(set) var battery: Percentage = Percentage.max
    public private(set) var charging: Bool = false
}

extension ChargingClass: Parser {

}

extension ChargingClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is Charging.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: Charging.self) else {
            return
        }

        isAvailable = true
    }
}

extension ChargingClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let charging = response as? Charging else {
            return nil
        }

        guard let batteryLevel = charging.batteryLevel,
            let chargingState = charging.chargingState else {
                return nil
        }

        self.battery = batteryLevel
        self.charging = chargingState == .charging

        return .other(self)
    }
}

extension ChargingClass: VehicleStatusParser {

}
