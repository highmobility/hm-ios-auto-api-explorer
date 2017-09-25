//
//  Lights.swift
//  Car
//
//  Created by Mikk RÃ¤tsep on 07/07/2017.
//  Copyright Â© 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class Lights: Command {

    public enum FrontLightState: UInt8 {
        // Blatant copy from AutoAPI
        case inactive   = 0x00
        case active     = 0x01
        case fullBeam   = 0x02
        // Except this
        case unknown    = 0xFF
    }


    public private(set) var frontExteriorLightsState: FrontLightState = .unknown
    public private(set) var interiorLightsActive: Bool = false
    public private(set) var rearLightsActive: Bool = false
}

extension Lights: Parser {

}

extension Lights: Hashable {

    public var hashValue: Int {
        return frontExteriorLightsState.hashValue + interiorLightsActive.hashValue
    }


    public static func ==(lhs: Lights, rhs: Lights) -> Bool {
        return (lhs.frontExteriorLightsState == rhs.frontExteriorLightsState) && (lhs.interiorLightsActive == rhs.interiorLightsActive)
    }
}

extension Lights: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.LightsCommand.Capability else {
            return
        }

        // Check the values
        guard capability.exteriorLights == .available else {
            return
        }

        guard capability.interiorLights == .available else {
            return
        }

        becameAvailable(self)
    }
}

extension Lights: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.LightsCommand.Response else {
            return nil
        }

        // Extract the values
        guard let frontLights = FrontLightState(rawValue: response.frontExteriorLights.rawValue) else {
            return nil
        }

        frontExteriorLightsState = frontLights
        interiorLightsActive = response.interiorLights == .active
        rearLightsActive = response.rearExteriorLights == .active

        return .other(self)
    }
}

extension Lights: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.LightsCommand.VehicleStatus else {
            return
        }

        // Extract the values
        guard let frontLights = FrontLightState(rawValue: vehicleStatus.frontExteriorLights.rawValue) else {
            return
        }

        frontExteriorLightsState = frontLights
        interiorLightsActive = vehicleStatus.interiorLights == .active
        rearLightsActive = vehicleStatus.rearExteriorLights == .active
    }
}
