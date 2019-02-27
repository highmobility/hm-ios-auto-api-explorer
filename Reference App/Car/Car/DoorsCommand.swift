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

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AADoorLocks.Type,
            capability.supportsAllMessageTypes(for: AADoorLocks.self) else {
                return
        }

        isAvailable = true
    }
}

extension DoorsCommand: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let doorLocks = response as? AADoorLocks,
            let locks = doorLocks.locks,
            let positions = doorLocks.positions?.compactMap({ $0.value }) else {
                return nil
        }

        locked = locks.compactMap {
            $0.value
        }.allSatisfy {
            $0.lock == .locked
        }

        doors = locks.compactMap {
            $0.value
        }.compactMap { lock in
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

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AADoorLocks.Type,
            capability.supports(AADoorLocks.MessageTypes.locksState) else {
                return
        }

        isAvailable = true
    }
}

extension DoorsStatusCommand: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let doorLocks = response as? AADoorLocks,
            let locks = doorLocks.locks,
            let positions = doorLocks.positions?.compactMap({ $0.value }) else {
                return nil
        }

        doors = locks.compactMap {
            $0.value
        }.compactMap { lock in
            guard let position = positions.first(where: { $0.location == lock.location }) else {
                return nil
            }

            return DoorClass(lock: lock, position: position)
        }

        return .other(self)
    }
}
