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

        let bytes = HonkHornFlashFlights.activateEmergencyFlasher(activate)

        print("- Car - send emergency flasher command, activate \(activate)")

        // This is a workaround for keeping the state, 'cause that command doesn't have a response
        sendCommand(bytes) {
            if $0 != nil {
                self.honkHornFlashLights.emergencyFlasherOn = !activate
                self.notifyCommandParsed(.other(self.honkHornFlashLights))
            }

            failed($0)
        }

        // The workaround also sends out the state change after a faked delay
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.honkHornFlashLights.emergencyFlasherOn = activate
            self.notifyCommandParsed(.other(self.honkHornFlashLights))
        }
    }
}
