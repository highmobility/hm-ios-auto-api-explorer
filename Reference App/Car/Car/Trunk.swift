//
//  Trunk.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Trunk: Command {

    public private(set) var locked: Bool = false
    public private(set) var open: Bool = false
}

extension Trunk: Parser {

}

extension Trunk: Hashable {

    public var hashValue: Int {
        return locked.hashValue + open.hashValue
    }


    public static func ==(lhs: Trunk, rhs: Trunk) -> Bool {
        return (lhs.locked == rhs.locked) && (lhs.open == rhs.open)
    }
}

extension Trunk: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.TrunkAccessCommand.Capability else {
            return
        }

        // Check the values
        guard capability.lock == .available else {
            return 
        }

        guard capability.position == .available else {
            return
        }

        becameAvailable(self)
    }
}

extension Trunk: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.TrunkAccessCommand.Response else {
            return nil
        }

        locked = response.lock == .locked
        open = response.position == .open

        return .other(self)
    }
}

extension Trunk: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.TrunkAccessCommand.VehicleStatus else {
            return
        }

        locked = vehicleStatus.lockStatus == .locked
        open = vehicleStatus.positionStatus == .open
    }
}
