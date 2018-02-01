//
//  RemoteControlClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func getRemoteControlStatus(failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RemoteControl.getControlMode

        print("- Car - get remote control state")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlDrivingCommand(angle: RemoteControlClass.Angle, speed: RemoteControlClass.Speed, failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RemoteControl.controlCommand(RemoteControl.Control(speed: speed, angle: angle))

        print("- Car - send remote control command, angle: \(angle), speed: \(speed)")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlStartCommand(failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RemoteControl.startControlMode

        print("- Car - send remote control command, START")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlStopCommand(failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = RemoteControl.stopControlMode

        print("- Car - send remote control command, STOP")

        sendCommand(bytes, failed: failed)
    }
}
