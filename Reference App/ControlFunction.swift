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
        case lightsFront        = "Front Lights"
        case lightsInterior     = "Interior Lights"
        case lightsRear         = "Rear Lights"
        case remoteControl      = "Remote Control"
        case rooftopDimming     = "Rooftop Dimming"
        case rooftopOpening     = "Rooftop Opening"
        case trunkAccess        = "Trunk Access"
        case windshieldHeating  = "Windshield Heating"
    }


    let name: String
    let kind: Kind

    private(set) var isStatusReceived: Bool = false


    // MARK: Methods

    func receivedUpdate(_ command: Command) {
        isStatusReceived = true
    }


    // MARK: Initialiser

    init(kind: Kind) {
        self.name = kind.rawValue
        self.kind = kind
    }
}
