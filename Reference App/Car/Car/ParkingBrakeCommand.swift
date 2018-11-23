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

    func update(from capability: AACapability) {
        guard capability.command is AAParkingBrake.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AAParkingBrake.self) else {
            return
        }

        isAvailable = true
    }
}

extension ParkingBrakeCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let parkingBrake = response as? AAParkingBrake else {
            return nil
        }

        guard let state = parkingBrake.state else {
            return nil
        }

        self.isActive = state == .active

        return .other(self)
    }
}
