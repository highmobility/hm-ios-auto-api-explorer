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

    public typealias Percentage = Double


    public private(set) var battery: Percentage = .nan
    public private(set) var charging: Bool = false
}

extension ChargingClass: Parser {

}

extension ChargingClass: CapabilityParser {

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AACharging.Type,
            capability.supportsAllMessageTypes(for: AACharging.self) else {
                return
        }

        isAvailable = true
    }
}

extension ChargingClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let charging = response as? AACharging,
            let batteryLevel = charging.batteryLevel?.value,
            let chargingState = charging.state?.value else {
                return nil
        }

        self.battery = batteryLevel
        self.charging = chargingState == .charging

        return .other(self)
    }
}
