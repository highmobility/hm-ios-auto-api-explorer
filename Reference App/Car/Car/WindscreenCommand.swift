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

    func update(from capability: AACapability) {
        guard capability.command is AAWindscreen.Type else {
            return
        }

        guard capability.supports(AAWindscreen.MessageTypes.getWindscreenState, .windscreenState) else {
            return
        }

        isAvailable = true
    }
}

extension WindscreenCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let windscreen = response as? AAWindscreen else {
            return nil
        }

        guard let damage = windscreen.damage else {
            return nil
        }

        switch damage {
        case .small, .big:
            hasDamage = true
        default:
            hasDamage = false
        }

        return .other(self)
    }
}
