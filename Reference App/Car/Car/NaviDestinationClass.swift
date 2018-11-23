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

    func update(from capability: AACapability) {
        guard capability.command is AANaviDestination.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AANaviDestination.self) else {
            return
        }

        isAvailable = true
    }
}

extension NaviDestinationClass: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let naviDestination = response as? AANaviDestination else {
            return nil
        }

        guard let coordinate = naviDestination.coordinates,
            let name = naviDestination.name else {
                return nil
        }

        self.coordinate = coordinate
        self.name = name

        return .other(self)
    }
}
