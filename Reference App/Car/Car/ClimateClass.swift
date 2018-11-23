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

    func update(from capability: AACapability) {
        guard capability.command is AAClimate.Type else {
            return
        }

        guard capability.supports(AAClimate.MessageTypes.getClimateState, .climateState, .startStopHVAC, .startStopDefrosting) else {
            return
        }

        isAvailable = true
    }
}

extension ClimateClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let climate = response as? AAClimate else {
            return nil
        }

        guard let hvacState = climate.hvacState,
            let defrostingState = climate.defrostingState else {
                return nil
        }

        hvacActive = hvacState == .active
        windshieldDefrosting = defrostingState == .active

        return .other(self)
    }
}
