//
//  Doors.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Doors: Command {

    public private(set) var locked: Bool = false
}

extension Doors: Parser {

}

extension Doors: Hashable {

    public var hashValue: Int {
        return locked.hashValue
    }

    public static func ==(lhs: Doors, rhs: Doors) -> Bool {
        return lhs.locked == rhs.locked
    }
}

extension Doors: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.DoorLocksCommand.Capability else {
            return
        }

        guard capability == .available else {
            return
        }

        becameAvailable(self)
    }
}

extension Doors: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.DoorLocksCommand.Response else {
            return nil
        }

        locked = !response.doors.contains { $0.lockStatus == .unlocked }

        return .other(self)
    }
}

extension Doors: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.DoorLocksCommand.VehicleStatus else {
            return
        }

        locked = !vehicleStatus.doors.contains { $0.lockStatus == .unlocked }
    }
}
