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

    func update(from capability: Capability) {
        guard capability.command is ParkingBrake.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: ParkingBrake.self) else {
            return
        }

        isAvailable = true
    }
}

extension ParkingBrakeCommand: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let parkingBrake = response as? ParkingBrake else {
            return nil
        }

        guard let isActive = parkingBrake.isActive else {
            return nil
        }

        self.isActive = isActive

        return .other(self)
    }
}
