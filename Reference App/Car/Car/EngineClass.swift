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

    func update(from capability: AACapability) {
        guard capability.command is AAEngine.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AAEngine.self) else {
            return
        }

        isAvailable = true
    }
}

extension EngineClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let engine = response as? AAEngine else {
            return nil
        }

        guard let ignitionState = engine.ignitionState else {
            return nil
        }

        on = ignitionState == .active

        return .other(self)
    }
}
