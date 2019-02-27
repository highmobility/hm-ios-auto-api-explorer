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

    func update(from capability: AACapabilityValue) {
        guard capability.capability is AATrunkAccess.Type,
            capability.supportsAllMessageTypes(for: AATrunkAccess.self) else {
                return
        }

        isAvailable = true
    }
}

extension TrunkClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let trunkAccess = response as? AATrunkAccess,
            let lockState = trunkAccess.lock?.value,
            let positionState = trunkAccess.position?.value else {
                return nil
        }

        locked = lockState == .locked
        open = positionState == .open

        return .other(self)
    }
}
