//
//  RooftopClass.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class RooftopClass: CommandClass {

    public private(set) var dimmed: Bool = false
    public private(set) var open: Bool = false
}

extension RooftopClass: Parser {

}

extension RooftopClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is RooftopControl.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: RooftopControl.self) else {
            return
        }

        isAvailable = true
    }
}

extension RooftopClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let rooftop = response as? RooftopControl else {
            return nil
        }

        guard let dimmingState = rooftop.dimming,
            let openState = rooftop.position else {
                return nil
        }

        dimmed = dimmingState == 100
        open = openState == 100

        return .other(self)
    }
}

extension RooftopClass: VehicleStatusParser {

}
