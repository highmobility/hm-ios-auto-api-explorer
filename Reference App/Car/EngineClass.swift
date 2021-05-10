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

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AAIgnition.identifier,
            capability.supportsAllProperties(for: AAIgnition.PropertyIdentifier.self) else {
                return
        }

        isAvailable = true
    }
}

extension EngineClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let ignition = response as? AAIgnition,
              let ignitionState = ignition.state?.value else {
                return nil
        }

        on = ignitionState == .on

        return .other(self)
    }
}
