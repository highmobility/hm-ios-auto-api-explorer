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

    func update(from capability: AACapability) {
        guard capability.command is AAHonkHornFlashLights.Type else {
            return
        }

        guard capability.supports(AAHonkHornFlashLights.MessageTypes.honkFlash) else {
            return
        }

        isAvailable = true
    }
}

extension HonkHornFlashLightsClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let honkFlash = response as? AAHonkHornFlashLights else {
            return nil
        }

        guard let flasherState = honkFlash.flasherState else {
            return nil
        }

        emergencyFlasherOn = flasherState == .emergencyFlasherActive

        return .other(self)
    }
}
