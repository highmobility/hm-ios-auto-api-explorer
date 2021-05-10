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
    public private(set) var rearLightsActive: Bool = false

    public var interiorLightsActive: Bool {
        return interiorLamps.contains(where: { $0.state == .active })
    }

    private(set) var interiorLamps: [AALight] = []
}

extension LightsClass: Parser {

}

extension LightsClass: CapabilityParser {

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AALights.identifier,
            capability.supportsAllProperties(for: AALights.PropertyIdentifier.self) else {
                return
        }

        isAvailable = true
    }
}

extension LightsClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let lights = response as? AALights,
            let frontExteriorState = lights.frontExteriorLight?.value,
            let frontLightsState = FrontExteriorLightState(rawValue: frontExteriorState.byteValue),
            let interiorState = lights.interiorLights,
            let rearExteriorState = lights.rearExteriorLight?.value else {
                return nil
        }

        frontExteriorLightsState = frontLightsState
        interiorLamps = interiorState.compactMap { $0.value }
        rearLightsActive = rearExteriorState == .active

        return .other(self)
    }
}
