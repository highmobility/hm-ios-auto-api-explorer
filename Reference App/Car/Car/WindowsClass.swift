//
//  WindowsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class WindowsClass: CommandClass {

    public private(set) var open: Bool = false


    internal private(set) var positions: [Position] = []
}

extension WindowsClass: Parser {

}

extension WindowsClass: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is WindowsClass.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: Windows.self) else {
            return
        }

        isAvailable = true
    }
}

extension WindowsClass: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let windows = response as? Windows else {
            return nil
        }

        open = windows.contains { $0.openClosed == .open }
        positions = windows.map { $0.position }

        return .other(self)
    }
}

extension WindowsClass: VehicleStatusParser {

}
