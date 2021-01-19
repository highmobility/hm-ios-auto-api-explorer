//
//  HonkHornFlashLightsClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    func sendEmergencyFlasherCommand(activate: Bool, failed: @escaping CommandFailed) {
        guard honkHornFlashLights.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAHonkHornFlashLights.activateDeactivateEmergencyFlasher(emergencyFlashersState: activate ? .active : .inactive)

        print("- Car - send emergency flasher command, activate \(activate)")

        sendCommand(bytes, failed: failed)
    }

    func sendHonkHornFlashLightsOnce(failed: @escaping CommandFailed) {
        guard honkHornFlashLights.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAHonkHornFlashLights.honkFlash(flashTimes: 1, honkTime: .init(value: 1.0, unit: .seconds))

        print("- Car - send honk horn 1 sec, flash lights once")

        sendCommand(bytes, failed: failed)

        // This is a workaround for now
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.notifyCommandParsed(.other(self.honkHornFlashLights))
        }
    }
}
