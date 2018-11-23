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

    public func sendEmergencyFlasherCommand(activate: Bool, failed: @escaping CommandFailed) {
        guard honkHornFlashLights.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAHonkHornFlashLights.activateEmergencyFlasher(activate ? .active : .inactive)

        print("- Car - send emergency flasher command, activate \(activate)")

        sendCommand(bytes, failed: failed)
    }

    public func sendHonkHornFlashLightsOnce(failed: @escaping CommandFailed) {
        guard honkHornFlashLights.isAvailable else {
            return failed(.needsInitialState)
        }

        guard let bytes = AAHonkHornFlashLights.honkHorn(seconds: 1, flashLightsXTimes: 1) else {
            return failed(.invalidValues)
        }

        print("- Car - send honk horn 1 sec, flash lights once")

        sendCommand(bytes, failed: failed)

        // This is a workaround for now
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.notifyCommandParsed(.other(self.honkHornFlashLights))
        }
    }
}
