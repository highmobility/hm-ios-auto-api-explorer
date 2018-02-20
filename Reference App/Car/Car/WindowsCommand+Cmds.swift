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

    public func getWindowsState(failed: @escaping CommandFailed) {
        guard windows.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = Windows.getWindowsState

        print("- Car - get windows state")

        sendCommand(bytes, failed: failed)
    }

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
