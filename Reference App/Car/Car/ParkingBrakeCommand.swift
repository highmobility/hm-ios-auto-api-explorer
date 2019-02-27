//
//  ParkingBrakeCommand.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class ParkingBrakeCommand: CommandClass {

    public private(set) var isActive: Bool = false
}

extension ParkingBrakeCommand: Parser {

}

extension ParkingBrakeCommand: CapabilityParser {

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AAParkingBrake.Type,
            capability.supportsAllMessageTypes(for: AAParkingBrake.self) else {
                return
        }

        isAvailable = true
    }
}

extension ParkingBrakeCommand: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let parkingBrake = response as? AAParkingBrake,
            let state = parkingBrake.state?.value else {
                return nil
        }

        self.isActive = state == .active

        return .other(self)
    }
}
