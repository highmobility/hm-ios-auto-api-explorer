//
//  Capabilities.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


class Capabilities {

    let parseCapability: (Capability) -> Void


    init(parseCapability: @escaping (Capability) -> Void) {
        self.parseCapability = parseCapability
    }
}

extension Capabilities: ParserResponseOnly {

}

extension Capabilities: HashableEmpty {

}

extension Capabilities: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.CapabilitiesCommand.Response else {
            return nil
        }

        response.capabilities.forEach {
            self.parseCapability($0)
        }

        Car.shared.displayStuffInThing("tere")

        return .capabilities
    }
}
