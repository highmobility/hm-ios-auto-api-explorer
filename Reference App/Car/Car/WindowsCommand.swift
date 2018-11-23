//
//  WindowsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class WindowClass {

    public let isOpen: Bool
    public let location: Location

    let position: AALocation


    init(open: AAWindowPosition) {
        isOpen = open.position == .open
        location = Location(position: open.location)

        position = open.location
    }
}


public class WindowsCommand: CommandClass {

    public private(set) var open: Bool = false
    public private(set) var windows: [WindowClass] = []
}

extension WindowsCommand: Parser {

}

extension WindowsCommand: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AAWindows.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: AAWindows.self) else {
            return
        }

        isAvailable = true
    }
}

extension WindowsCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let windows = response as? AAWindows else {
            return nil
        }

        guard let positions = windows.positions else {
            return nil
        }

        self.open = positions.filter { $0.location != .hatch }.contains { $0.position == .open }
        self.windows = positions.map { WindowClass(open: $0) }

        return .other(self)
    }
}


public class WindowsStatusCommand: CommandClass {

    public private(set) var windows: [WindowClass] = []
}

extension WindowsStatusCommand: Parser {

}

extension WindowsStatusCommand: CapabilityParser {

    func update(from capability: AACapability) {
        guard capability.command is AAWindows.Type else {
            return
        }

        guard capability.supports(AAWindows.MessageTypes.windowsState) else {
            return
        }

        isAvailable = true
    }
}

extension WindowsStatusCommand: ResponseParser {

    @discardableResult func update(from response: AACommand) -> CommandType? {
        guard let windows = response as? AAWindows else {
            return nil
        }

        guard let positions = windows.positions else {
            return nil
        }

        self.windows = positions.map { WindowClass(open: $0) }

        return .other(self)
    }
}
