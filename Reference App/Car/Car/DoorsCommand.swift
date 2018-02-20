//
//  DoorsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class DoorClass {
    public let isLocked: Bool
    public let isOpen: Bool
    public let location: Location


    init(door: Door) {
        isLocked = door.lock == .locked
        isOpen = door.position == .open
        location = Location(position: door.location)
    }
}


public class DoorsCommand: CommandClass {

    public private(set) var doors: [DoorClass] = []
    public private(set) var locked: Bool = false
}

extension DoorsCommand: Parser {

}

extension DoorsCommand: CapabilityParser {

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

extension DoorsCommand: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let doorLocks = response as? DoorLocks else {
            return nil
        }

        guard let doors = doorLocks.doors else {
            return nil
        }

        self.doors = doors.map { DoorClass(door: $0) }
        self.locked = !doors.contains { $0.lock == .unlocked }

        return .other(self)
    }
}
