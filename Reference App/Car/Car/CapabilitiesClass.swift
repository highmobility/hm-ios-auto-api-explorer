//
//  Capabilities.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


class CapabilitiesClass: CommandClass {

    let parseCapability: (Capability) -> Void


    init(parseCapability: @escaping (Capability) -> Void) {
        self.parseCapability = parseCapability

        super.init()

        isAvailable = true
        isMetaCommand = true
    }
}

extension CapabilitiesClass: ParserResponseOnly {

}

extension CapabilitiesClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let capabilities = response as? Capabilities else {
            return nil
        }

        capabilities.forEach {
            self.parseCapability($0)
        }

        return .capabilities
    }
}
