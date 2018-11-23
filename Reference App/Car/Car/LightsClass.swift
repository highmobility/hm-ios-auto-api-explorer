//
//  LightsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class LightsClass: CommandClass {

    public enum FrontExteriorLightState: UInt8 {
        // Blatant copy from AutoAPI
        case inactive   = 0x00
        case active     = 0x01
        case fullBeam   = 0x02
        // Except this
        case unknown    = 0xFF
    }


    public private(set) var frontExteriorLightsState: FrontExteriorLightState = .unknown
    public private(set) var interiorLightsActive: Bool = false
    public private(set) var rearLightsActive: Bool = false
}

extension LightsClass: Parser {

}

extension LightsClass: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AALights.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AALights.self) else {
            return
        }

        isAvailable = true
    }
}

extension LightsClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let lights = response as? AALights else {
            return nil
        }

        // Extract the values
        guard let frontExteriorState = lights.frontExterior, let frontLightsState = FrontExteriorLightState(rawValue: frontExteriorState.rawValue) else {
            return nil
        }

        guard let interiorState = lights.interiorState else {
            return nil
        }

        guard let rearExteriorState = lights.rearExteriorState else {
            return nil
        }

        frontExteriorLightsState = frontLightsState
        interiorLightsActive = interiorState == .active
        rearLightsActive = rearExteriorState == .active

        return .other(self)
    }
}
