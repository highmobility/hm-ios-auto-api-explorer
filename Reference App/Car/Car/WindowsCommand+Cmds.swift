//
//  WindowsCommand+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public extension Car {

    public func sendWindowsCommand(open: Bool, failed: @escaping CommandFailed) {
        guard self.windows.isAvailable else {
            return failed(.needsInitialState)
        }

        let state: Window.OpenClosed = open ? .open : .close
        let windows: [Window] = self.windows.windows.map { Window(openClosed: state, position: $0.position) }
        let bytes = Windows.openClose(windows)

        print("- Car - send windows command, open: \(open)")

        sendCommand(bytes, failed: failed)
    }
}
