//
//  RemoteControlClass.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class RemoteControlClass: CommandClass {

    public typealias Angle = Int16
    public typealias Speed = Int8


    public enum ControlModeStatus: UInt8 {
        // Blatant copy from AutoAPI
        case unavailable    = 0x00
        case available      = 0x01
        case started        = 0x02
        case failedToStart  = 0x03
        case aborted        = 0x04
        case ended          = 0x05
        // Except this
        case unknown        = 0xFF
    }


    public private(set) var angle: Angle = Angle.max
    public private(set) var controlMode: ControlModeStatus = .unknown
}

extension RemoteControlClass: Parser {

}

extension RemoteControlClass: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AARemoteControl.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AARemoteControl.self) else {
            return
        }

        isAvailable = true
    }
}

extension RemoteControlClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let remoteControl = response as? AARemoteControl else {
            return nil
        }

        guard let controlMode = remoteControl.controlMode,
            let angle = remoteControl.angle else {
                return nil
        }

        guard let controlModeStatus = ControlModeStatus(rawValue: controlMode.rawValue) else {
            return nil
        }

        self.angle = angle
        self.controlMode = controlModeStatus

        return .other(self)
    }
}
