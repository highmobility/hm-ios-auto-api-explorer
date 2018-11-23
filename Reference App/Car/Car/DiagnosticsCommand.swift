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

    func update(from capability: AACapability) {
        guard capability.command is AADiagnostics.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AADiagnostics.self) else {
            return
        }

        isAvailable = true
    }
}

extension DiagnosticsCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let diagnostics = response as? AADiagnostics else {
            return nil
        }

        guard let mileage = diagnostics.mileage,
            let speed = diagnostics.speed else {
                return nil
        }

        self.mileage = mileage
        self.speed = speed

        return .other(self)
    }
}
