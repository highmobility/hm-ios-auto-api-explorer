//
//  TrunkClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class TrunkClass: CommandClass {

    public private(set) var locked: Bool = false
    public private(set) var open: Bool = false
}

extension TrunkClass: Parser {

}

extension TrunkClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is TrunkAccess.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: TrunkAccess.self) else {
            return
        }

        isAvailable = true
    }
}

extension TrunkClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let trunkAccess = response as? TrunkAccess else {
            return nil
        }

        guard let lockState = trunkAccess.lock,
            let positionState = trunkAccess.position else {
                return nil
        }

        locked = lockState == .locked
        open = positionState == .open

        return .other(self)
    }
}

extension TrunkClass: VehicleStatusParser {

}
