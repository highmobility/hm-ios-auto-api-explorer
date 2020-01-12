//
//  HonkHornFlashLightsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class HonkHornFlashLightsClass: CommandClass {

    public internal(set) var emergencyFlasherOn: Bool = false
}

extension HonkHornFlashLightsClass: Parser {

}

extension HonkHornFlashLightsClass: CapabilityParser {

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AAHonkHornFlashLights.identifier,
            capability.supports(propertyIDs: AAHonkHornFlashLights.PropertyIdentifier.flashers.rawValue) else {
                return
        }

        isAvailable = true
    }
}

extension HonkHornFlashLightsClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let honkFlash = response as? AAHonkHornFlashLights,
            let flasherState = honkFlash.flashers?.value else {
                return nil
        }

        emergencyFlasherOn = flasherState == .emergencyFlasherActive

        return .other(self)
    }
}
