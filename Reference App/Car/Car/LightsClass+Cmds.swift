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

        let bytes = AALights.getLightsState

        print("- Car - get lights state")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(frontExteriorLights: LightsClass.FrontExteriorLightState, failed: @escaping CommandFailed) {
        guard let frontExterior = AAFrontLightState(rawValue: frontExteriorLights.rawValue) else {
            return failed(.invalidValues)
        }

        guard let bytes = AALights.controlLights(frontExterior: frontExterior, rearExterior: nil, interior: nil, ambientColour: nil) else {
            return failed(.invalidValues)
        }

        print("- Car - send lights command, frontExteriorLights: \(frontExteriorLights)")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(interiorLightsActive: Bool, failed: @escaping CommandFailed) {
        guard let bytes = AALights.controlLights(frontExterior: nil, rearExterior: nil, interior: (interiorLightsActive ? .active : .inactive), ambientColour: nil) else {
            return failed(.invalidValues)
        }

        print("- Car - send lights command, interiorLights active: \(interiorLightsActive)")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(rearLightsActive: Bool, failed: @escaping CommandFailed) {
        guard let bytes = AALights.controlLights(frontExterior: nil, rearExterior: (rearLightsActive ? .active : .inactive), interior: nil, ambientColour: nil) else {
            return failed(.invalidValues)
        }

        print("- Car - send lights command, rearLights active: \(rearLightsActive)")

        sendCommand(bytes, failed: failed)
    }
}
