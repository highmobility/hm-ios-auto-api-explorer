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

    let parseCapability: (AACapabilityValue) -> Void


    init(parseCapability: @escaping (AACapabilityValue) -> Void) {
        self.parseCapability = parseCapability

        super.init()

        isAvailable = true
        isMetaCommand = true
    }
}

extension CapabilitiesClass: ParserResponseOnly {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let capabilities = response as? AACapabilities else {
            return nil
        }

        capabilities.capabilities?.compactMap {
            $0.value
        }.forEach {
            self.parseCapability($0)
        }

        return .capabilities
    }
}
