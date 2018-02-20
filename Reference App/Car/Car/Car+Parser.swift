//
//  Car+Parser.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


extension Car {

    var capabilityParsers: [CapabilityParser] {
        return commands.flatMap { $0 as? CapabilityParser }
    }

    var responseParsers: [ResponseParser] {
        return commands.flatMap { $0 as? ResponseParser }
    }


    // MARK: Methods - Parsing

    func parseCapability(_ capability: Capability) {
        capabilityParsers.forEach {
            $0.update(from: capability)
        }
    }

    func parseResponse(_ response: Command) {
        // There can only be ONE matching response
        let matchingParsers = responseParsers.flatMap { $0.update(from: response) }

        guard let commandType = matchingParsers.first else {
            return
        }

        notifyCommandParsed(commandType)
    }
}
