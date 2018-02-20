//
//  ControlFunction.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


class ControlFunction {

    enum Kind: String {
        case charging           = "Charging"
        case doorsLock          = "Door Locks"
        case doorsStatus        = "Doors Status"
        case emergencyFlasher   = "Emergency Flasher"
        case engine             = "Engine"
        case honkFlash          = "Honk and Flash"
        case hvac               = "HVAC"
        case lightsFront        = "Front Lights"
        case lightsInterior     = "Interior Lights"
        case lightsRear         = "Rear Lights"
        case naviDestination    = "Navi Destination"
        case parkingBrake       = "Parking Brake"
        case remoteControl      = "Remote Control"
        case rooftopDimming     = "Rooftop Dimming"
        case rooftopOpening     = "Rooftop Opening"
        case trunkAccess        = "Trunk Access"
        case vehicleLocation    = "Vehicle Location"
        case windshieldHeating  = "Windshield Heating"
        case windows            = "Windows"
        case windowsStatus      = "Windows Status"
    }


    let name: String
    let kind: Kind

    private(set) var isStatusReceived: Bool = false


    // MARK: Methods

    func receivedUpdate(_ command: CommandClass) {
        isStatusReceived = true
    }


    // MARK: Initialiser

    init(kind: Kind) {
        self.name = kind.rawValue
        self.kind = kind
    }
}

