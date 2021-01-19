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

    func getNaviDestination(failed: @escaping CommandFailed) {
        guard naviDestination.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AANaviDestination.getNaviDestination()

        print("- Car - get navi destination")

        sendCommand(bytes, failed: failed)
    }

    func sendNaviDestination(coordinate: CLLocationCoordinate2D, name: String, failed: @escaping CommandFailed) {
        guard naviDestination.isAvailable else {
            return failed(.needsInitialState)
        }

        let coordinates = AACoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let bytes = AANaviDestination.setNaviDestination(coordinates: coordinates, destinationName: name).bytes

        print("- Car - send navi destination, name:", name)

        sendCommand(bytes, failed: failed)
    }
}
