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

    func getLightsState(failed: @escaping CommandFailed) {
        guard lights.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AALights.getLightsState.bytes

        print("- Car - get lights state")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(frontExteriorLights: LightsClass.FrontExteriorLightState, failed: @escaping CommandFailed) {
        guard let frontExterior = AAFrontLightState(rawValue: frontExteriorLights.rawValue),
            let bytes = AALights.controlLights(frontExterior: frontExterior)?.bytes else {
                return failed(.invalidValues)
        }

        print("- Car - send lights command, frontExteriorLights: \(frontExteriorLights)")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(interiorLightsActive: Bool, failed: @escaping CommandFailed) {
        let lamps = lights.interiorLamps.map {
            AAInteriorLamp(location: $0.location, state: interiorLightsActive ? .active : .inactive)
        }

        guard let bytes = AALights.controlLights(interiorLamps: lamps)?.bytes else {
            return failed(.invalidValues)
        }

        print("- Car - send lights command, interiorLights active: \(interiorLightsActive)")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(rearLightsActive: Bool, failed: @escaping CommandFailed) {
        guard let bytes = AALights.controlLights(rearExterior: rearLightsActive ? .active : .inactive)?.bytes else {
            return failed(.invalidValues)
        }

        print("- Car - send lights command, rearLights active: \(rearLightsActive)")

        sendCommand(bytes, failed: failed)
    }
}
