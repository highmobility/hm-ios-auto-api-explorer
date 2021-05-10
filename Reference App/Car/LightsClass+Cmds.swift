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

        let bytes = AALights.getLightsState()

        print("- Car - get lights state")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(frontExteriorLights: LightsClass.FrontExteriorLightState, failed: @escaping CommandFailed) {
        guard let frontExterior = AALights.FrontExteriorLight(bytes: [frontExteriorLights.rawValue]) else {
            return failed(.invalidValues)
        }

        let bytes = AALights.controlLights(frontExteriorLight: frontExterior)

        print("- Car - send lights command, frontExteriorLights: \(frontExteriorLights)")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(interiorLightsActive: Bool, failed: @escaping CommandFailed) {
        let lamps = lights.interiorLamps.map {
            AALight(location: $0.location, state: interiorLightsActive ? .active : .inactive)
        }

        let bytes = AALights.controlLights(interiorLights: lamps)

        print("- Car - send lights command, interiorLights active: \(interiorLightsActive)")

        sendCommand(bytes, failed: failed)
    }

    func sendLightsCommand(rearLightsActive: Bool, failed: @escaping CommandFailed) {
        let bytes = AALights.controlLights(rearExteriorLight: rearLightsActive ? .active : .inactive)

        print("- Car - send lights command, rearLights active: \(rearLightsActive)")

        sendCommand(bytes, failed: failed)
    }
}
