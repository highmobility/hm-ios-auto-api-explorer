//
//  Car.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation
import HMKit


public class Car {

    public static let shared = Car()


    // MARK: Vars


    public var activeVehicleSerial: Data?
    public var connectionMethod: ConnectionMethod

    public var availableCommands: [CommandClass] {
        return commands.filter { $0.isAvailable && !$0.isMetaCommand }
    }

    public internal(set) var connectionState: ConnectionState {
        didSet {
            guard connectionState != oldValue else {
                return
            }

            notifyConnectionStateUpdate(connectionState)
        }
    }

    public let charging = ChargingClass()
    public let climate = ClimateClass()
    public let diagnostics = DiagnosticsCommand()
    public let doors = DoorsCommand()
    public let engine = EngineClass()
    public let honkHornFlashLights = HonkHornFlashLightsClass()
    public let lights = LightsClass()
    public let naviDestination = NaviDestinationClass()
    public let parkingBrake = ParkingBrakeCommand()
    public let remoteControl = RemoteControlClass()
    public let rooftop = RooftopClass()
    public let trunk = TrunkClass()
    public let vehicleLocation = VehicleLocationClass()
    public let windows = WindowsCommand()
    public let windscreen = WindscreenCommand()


    var anyHashableObservers: Set<AnyHashable>
    var commands: [CommandClass]


    // MARK: Methods

    public func clearBroadcastingFilter() {
        LocalDevice.shared.clearBroadcastingFilter()
    }

    public func setBroadcastingFilter<C: Collection>(to vehicleSerial: C) where C.Iterator.Element == UInt8 {
        do {
            try LocalDevice.shared.setBroadcastingFilter(serial: vehicleSerial)
        }
        catch {
            print("Vehicle serial should be 9-bytes, error: \(error)")
        }
    }

    public func setTelematicsBasePath(to base: String) {
        Telematics.urlBasePath = base
    }


    // MARK: Initialiser

    private init() {
        // Some state-y vars
        activeVehicleSerial = nil
        connectionMethod = .bluetooth
        connectionState = .unavailable

        // Collections
        anyHashableObservers = Set()
        commands = [charging, climate, doors, diagnostics, engine, honkHornFlashLights, lights, naviDestination, parkingBrake, remoteControl, rooftop, trunk, vehicleLocation, windows, windscreen]

        // Initialise some of the LocalDevice things
        LocalDevice.loggingOptions = [.command, .error, .general, .bluetooth, .telematics, .urlRequests]
        LocalDevice.shared.delegate = self

        addMetaCommands()
    }

    private func addMetaCommands() {
        let capabilities = CapabilitiesClass(parseCapability: parseCapability)
        let failure = FailureMessageClass()
        let vs = VehicleStatii(parseStatus: parseResponse)

        commands.append(capabilities)
        commands.append(failure)
        commands.append(vs)
    }
}
