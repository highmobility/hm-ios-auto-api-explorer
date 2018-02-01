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

    func update(from capability: Capability) {
        guard capability.command is HonkHornFlashFlights.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: HonkHornFlashFlights.self) else {
            return
        }

        isAvailable = true
    }
}

extension HonkHornFlashLightsClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        return nil
    }
}

extension HonkHornFlashLightsClass: VehicleStatusParser {

}
