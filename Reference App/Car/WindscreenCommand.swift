//
//  WindscreenCommand.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class WindscreenCommand: CommandClass {

    public private(set) var hasDamage = false
}

extension WindscreenCommand: Parser {

}

extension WindscreenCommand: CapabilityParser {

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AAWindscreen.identifier,
            capability.supports(propertyIDs: AAWindscreen.PropertyIdentifier.windscreenDamage.rawValue) else {
                return
        }

        isAvailable = true
    }
}

extension WindscreenCommand: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let windscreen = response as? AAWindscreen,
            let damage = windscreen.windscreenDamage?.value else {
                return nil
        }

        switch damage {
        case .damageSmallerThan1Inch, .damageLargerThan1Inch:
            hasDamage = true
        default:
            hasDamage = false
        }

        return .other(self)
    }
}
