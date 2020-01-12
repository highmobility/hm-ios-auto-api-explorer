//
//  DiagnosticsCommand.swift
//  Car
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class DiagnosticsCommand: CommandClass {

    public private(set) var mileage: UInt32 = 0
    public private(set) var speed: Int16 = 0
}

extension DiagnosticsCommand: Parser {

}

extension DiagnosticsCommand: CapabilityParser {

    func update(from capability: AASupportedCapability) {
        guard capability.capabilityID == AADiagnostics.identifier,
            capability.supportsAllProperties(for: AADiagnostics.PropertyIdentifier.self) else {
                return
        }

        isAvailable = true
    }
}

extension DiagnosticsCommand: ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let diagnostics = response as? AADiagnostics,
            let mileage = diagnostics.mileage?.value,
            let speed = diagnostics.speed?.value else {
                return nil
        }

        self.mileage = mileage
        self.speed = speed

        return .other(self)
    }
}
