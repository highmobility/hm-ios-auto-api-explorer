//
//  DoorsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class DoorsClass: CommandClass {

    public private(set) var locked: Bool = false
}

extension DoorsClass: Parser {

}

extension DoorsClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is DoorLocks.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: DoorLocks.self) else {
            return
        }

        isAvailable = true
    }
}

extension DoorsClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let doorLocks = response as? DoorLocks else {
            return nil
        }

        guard let doors = doorLocks.doors else {
            return nil
        }

        locked = !doors.contains { $0.lock == .unlocked }

        return .other(self)
    }
}

extension DoorsClass: VehicleStatusParser {

}
