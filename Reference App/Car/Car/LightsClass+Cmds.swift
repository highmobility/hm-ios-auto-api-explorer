//
//  LightsClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getLightsState(failed: @escaping CommandFailed) {
        guard lights.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = Lights.getLightsState

        print("- Car - get lights state")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(frontExteriorLights: LightsClass.FrontExteriorLightState, failed: @escaping CommandFailed) {
        guard let frontExterior = FrontLightState(rawValue: frontExteriorLights.rawValue) else {
            return failed(.invalidValues)
        }

        let bytes = Lights.controlLights(.init(frontExterior: frontExterior, isRearExteriorActive: nil, isInteriorActive: nil, ambientColour: nil))

        print("- Car - send lights command, frontExteriorLights: \(frontExteriorLights)")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(interiorLightsActive: Bool, failed: @escaping CommandFailed) {
        let bytes = Lights.controlLights(.init(frontExterior: nil, isRearExteriorActive: nil, isInteriorActive: interiorLightsActive, ambientColour: nil))

        print("- Car - send lights command, interiorLights active: \(interiorLightsActive)")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(rearLightsActive: Bool, failed: @escaping CommandFailed) {
        let bytes = Lights.controlLights(.init(frontExterior: nil, isRearExteriorActive: rearLightsActive, isInteriorActive: nil, ambientColour: nil))

        print("- Car - send lights command, rearLights active: \(rearLightsActive)")

        sendCommand(bytes, failed: failed)
    }
}
