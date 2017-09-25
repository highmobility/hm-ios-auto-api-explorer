//
//  Lights+Cmds.swift
//  Car
//
//  Created by Mikk RÃ¤tsep on 08/07/2017.
//  Copyright Â© 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    private typealias LightsCommand = AutoAPI.LightsCommand


    public func getLightsState(failed: @escaping CommandFailed) {
        let bytes = AutoAPI.LightsCommand.getStateBytes

        print("- Car - get lights state")

        sendCommand(bytes, failed: failed)
    }

    public func sendLightsCommand(frontExteriorLights: Lights.FrontLightState, failed: @escaping CommandFailed) {
        do {
            let bytes = try lightsControlCommandBytes(frontState: frontExteriorLights, interiorActive: nil, rearActive: nil)

            print("- Car - send lights command, frontExteriorLights: \(frontExteriorLights)")

            sendCommand(bytes, failed: failed)
        }
        catch let error as CommandError {
            failed(error)
        }
        catch {
            failed(.miscellaneous(error))
        }
    }

    public func sendLightsCommand(interiorLightsActive: Bool, failed: @escaping CommandFailed) {
        do {
            let bytes = try lightsControlCommandBytes(frontState: nil, interiorActive: interiorLightsActive, rearActive: nil)

            print("- Car - send lights command, interiorLights active: \(interiorLightsActive)")

            sendCommand(bytes, failed: failed)
        }
        catch let error as CommandError {
            failed(error)
        }
        catch {
            failed(.miscellaneous(error))
        }
    }

    public func sendLightsCommand(rearLightsActive: Bool, failed: @escaping CommandFailed) {
        do {
            let bytes = try lightsControlCommandBytes(frontState: nil, interiorActive: nil, rearActive: rearLightsActive)

            print("- Car - send lights command, rearLights active: \(rearLightsActive)")

            sendCommand(bytes, failed: failed)
        }
        catch let error as CommandError {
            failed(error)
        }
        catch {
            failed(.miscellaneous(error))
        }
    }
}

private extension Car {

    func lightsControlCommandBytes(frontState: Lights.FrontLightState?, interiorActive: Bool?, rearActive: Bool?) throws -> Bytes {
        guard let lights = lights else {
            throw CommandError.needsInitialState
        }

        guard let frontState = LightsCommand.FrontExteriorLightsState(rawValue: frontState?.rawValue ?? lights.frontExteriorLightsState.rawValue) else {
            throw CommandError.invalidValues
        }

        let rearState: LightsCommand.RearExteriorLightsState = (rearActive ?? lights.rearLightsActive) ? .active : .inactive
        let interiorState: LightsCommand.InteriorLightsState = (interiorActive ?? lights.interiorLightsActive) ? .active : .inactive
        let ambientLightColour = UIColor.orange

        return LightsCommand.controlLightsBytes(frontState, rearState, interiorState, ambientLightColour)
    }
}
