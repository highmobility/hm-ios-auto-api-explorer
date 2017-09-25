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

    public internal(set) var connectionState: ConnectionState {
        didSet {
            guard connectionState != oldValue else {
                return
            }

            notifyConnectionStateUpdate(connectionState)
        }
    }

    public var allCommands: [Command?] {
        return [charging, climate, doors, lights, remoteControl, rooftop, trunk]
    }


    public internal(set) var charging: Charging? = nil
    public internal(set) var climate: Climate? = nil
    public internal(set) var doors: Doors? = nil
    public internal(set) var lights: Lights? = nil
    public internal(set) var remoteControl: RemoteControl? = nil
    public internal(set) var rooftop: Rooftop? = nil
    public internal(set) var trunk: Trunk? = nil


    var anyHashableObservers: Set<AnyHashable>
    var anyHashableParsers: Set<AnyHashable>


    // MARK: Methods

    // TODO: Check if this is still in use in 3 ticks: tick
    public func setBroadcastingFilter<C: Collection>(to vehicleSerial: C?) where C.Iterator.Element == UInt8 {
        if let serial = vehicleSerial {
            do {
                try LocalDevice.shared.setBroadcastingFilter(vehicleSerial: serial)
            }
            catch {
                print("Vehicle serial should be 9-bytes, error: \(error)")
            }
        }
        else {
            LocalDevice.shared.clearBroadcastingFilter()
        }
    }

    public func setTelematicsBasePath(to base: String) {
        Telematics.urlBasePath = base
    }


    // MARK: Initialiser

    private init() {
        activeVehicleSerial = nil
        connectionMethod = .bluetooth
        connectionState = .unavailable

        anyHashableObservers = Set()
        anyHashableParsers = Set()

        // Initialise some of the LocalDevice things
        LocalDevice.loggingOptions = [.command, .error, .general, .bluetooth]
        LocalDevice.shared.delegate = self

        addCommandsParsers()
        addMetaParsers()

        // Just a convenience
        setTelematicsBasePath(to: "https://developers.h-m.space/")
    }
}
