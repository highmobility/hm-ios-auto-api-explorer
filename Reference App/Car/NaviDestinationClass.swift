//
//  NaviDestinationClass.swift
//  Car
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import CoreLocation
import Foundation


public class NaviDestinationClass: CommandClass {

    public private(set) var coordinate = CLLocationCoordinate2D()
    public private(set) var name: String = ""
}

extension NaviDestinationClass: Parser {

}

extension NaviDestinationClass: CapabilityParser {

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AANaviDestination.identifier,
            capability.supportsAllProperties(for: AANaviDestination.PropertyIdentifier.self) else {
                return
        }

        isAvailable = true
    }
}

extension NaviDestinationClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let naviDestination = response as? AANaviDestination,
            let coordinate = naviDestination.coordinates?.value,
            let name = naviDestination.destinationName?.value else {
                return nil
        }

        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.name = name

        return .other(self)
    }
}
