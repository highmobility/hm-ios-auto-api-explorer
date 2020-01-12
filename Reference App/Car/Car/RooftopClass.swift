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

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AARooftopControl.identifier,
            capability.supportsAllProperties(for: AARooftopControl.PropertyIdentifier.self) else {
                return
        }

        isAvailable = true
    }
}

extension RooftopClass: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let rooftop = response as? AARooftopControl,
            let dimmingState = rooftop.dimming?.value,
            let openState = rooftop.position?.value else {
                return nil
        }

        dimmed = dimmingState == 1.0
        open = openState == 1.0

        return .other(self)
    }
}
