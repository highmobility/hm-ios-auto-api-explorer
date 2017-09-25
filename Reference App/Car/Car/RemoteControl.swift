//
//  RemoteControl.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class RemoteControl: Command {

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

extension RemoteControl: Parser {

}

extension RemoteControl: Hashable {

    public var hashValue: Int {
        return controlMode.hashValue
    }


    public static func ==(lhs: RemoteControl, rhs: RemoteControl) -> Bool {
        return lhs.controlMode == rhs.controlMode
    }
}

extension RemoteControl: CapabilityParser {

    func update(from capability: Capability) {
        guard let capability = capability.value as? AutoAPI.RemoteControlCommand.Capability else {
            return
        }

        guard capability == .available else {
            return
        }

        becameAvailable(self)
    }
}

extension RemoteControl: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.RemoteControlCommand.Response else {
            return nil
        }

        // Extract the values
        guard let controlMode = ControlModeStatus(rawValue: response.controlMode.rawValue) else {
            return nil
        }

        self.angle = response.angle
        self.controlMode = controlMode

        return .other(self)
    }
}

extension RemoteControl: VehicleStatusParser {

    func update(from vehicleStatus: VehicleStatus) {
        guard let vehicleStatus = vehicleStatus.value as? AutoAPI.RemoteControlCommand.VehicleStatus else {
            return
        }

        // Extract the values
        guard let controlMode = ControlModeStatus(rawValue: vehicleStatus.rawValue) else {
            return
        }

        self.controlMode = controlMode
    }
}
