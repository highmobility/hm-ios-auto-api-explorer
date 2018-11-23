//
//  NaviDestinationClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import CoreLocation
import Foundation


public extension Car {

    public func getNaviDestination(failed: @escaping CommandFailed) {
        guard naviDestination.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AANaviDestination.getDestination

        print("- Car - get navi destination")

        sendCommand(bytes, failed: failed)
    }

    public func sendNaviDestination(coordinate: CLLocationCoordinate2D, name: String, failed: @escaping CommandFailed) {
        guard naviDestination.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AANaviDestination.setDestination(coordinate: coordinate, name: name)

        print("- Car - send navi destination, name:", name)

        sendCommand(bytes, failed: failed)
    }
}
