//
//  EngineClass.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class EngineClass: CommandClass {

    public private(set) var on: Bool = false
}

extension EngineClass: Parser {

}

extension EngineClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is Engine.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: Engine.self) else {
            return
        }

        isAvailable = true
    }
}

extension EngineClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let engine = response as? Engine else {
            return nil
        }

        guard let ignitionState = engine.isIgnitionOn else {
            return nil
        }

        on = ignitionState

        return .other(self)
    }
}

extension EngineClass: VehicleStatusParser {

}
