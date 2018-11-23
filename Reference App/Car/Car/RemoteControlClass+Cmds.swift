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

        let bytes = AARemoteControl.getControlState

        print("- Car - get remote control state")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlDrivingCommand(angle: RemoteControlClass.Angle, speed: RemoteControlClass.Speed, failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AARemoteControl.controlCommand(angle: angle, speed: speed)

        print("- Car - send remote control command, angle: \(angle), speed: \(speed)")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlStartCommand(failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        guard let bytes = AARemoteControl.startStopControl(.start) else {
            return failed(.invalidValues)
        }

        print("- Car - send remote control command, START")

        sendCommand(bytes, failed: failed)
    }

    public func sendRemoteControlStopCommand(failed: @escaping CommandFailed) {
        guard remoteControl.isAvailable else {
            return failed(.needsInitialState)
        }

        guard let bytes = AARemoteControl.startStopControl(.stop) else {
            return failed(.invalidValues)
        }

        print("- Car - send remote control command, STOP")

        sendCommand(bytes, failed: failed)
    }
}
