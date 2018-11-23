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


    init(lock: AADoorLock, position: AADoorPosition) {
        isLocked = lock.lock == .locked
        isOpen = position.position != .closed
        location = Location(position: lock.location)
    }
}


public class DoorsCommand: CommandClass {

    public private(set) var doors: [DoorClass] = []
    public private(set) var locked: Bool = false
}

extension DoorsCommand: Parser {

}

extension DoorsCommand: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AADoorLocks.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AADoorLocks.self) else {
            return
        }

        isAvailable = true
    }
}

extension DoorsCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let doorLocks = response as? AADoorLocks else {
            return nil
        }

        guard let locks = doorLocks.locks,
            let positions = doorLocks.positions else {
                return nil
        }

        self.locked = locks.allSatisfy { $0.lock == .locked }
        self.doors = locks.compactMap { lock in
            guard let position = positions.first(where: { $0.location == lock.location }) else {
                return nil
            }

            return DoorClass(lock: lock, position: position)
        }

        return .other(self)
    }
}


public class DoorsStatusCommand: CommandClass {

    public private(set) var doors: [DoorClass] = []
}

extension DoorsStatusCommand: Parser {

}

extension DoorsStatusCommand: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AADoorLocks.Type else {
            return
        }

        guard capability.supports(AADoorLocks.MessageTypes.locksState) else {
            return
        }

        isAvailable = true
    }
}

extension DoorsStatusCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let doorLocks = response as? AADoorLocks else {
            return nil
        }

        guard let locks = doorLocks.locks,
            let positions = doorLocks.positions else {
                return nil
        }

        self.doors = locks.compactMap { lock in
            guard let position = positions.first(where: { $0.location == lock.location }) else {
                return nil
            }

            return DoorClass(lock: lock, position: position)
        }

        return .other(self)
    }
}
