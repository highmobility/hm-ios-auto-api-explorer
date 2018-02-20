//
//  ClimateClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class ClimateClass: CommandClass {

    public private(set) var hvacActive: Bool = false
    public private(set) var windshieldDefrosting: Bool = false
}

extension ClimateClass: Parser {

}

extension ClimateClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is ClimateClass.Type else {
            return
        }

        guard capability.supports(Climate.MessageTypes.getClimateState, .climateState, .setClimateProfile, .startStopHVAC, .startStopDefogging, .startStopDefrosting) else {
            return
        }

        isAvailable = true
    }
}

extension ClimateClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let climate = response as? Climate else {
            return nil
        }

        if let hvacState = climate.isHVACActive, hvacState {
            hvacActive = true
        }
        else {
            hvacActive = false
        }

        if let defrostingState = climate.isDefrostingActive, defrostingState {
            windshieldDefrosting = true
        }
        else {
            windshieldDefrosting = false
        }

        return .other(self)
    }
}
