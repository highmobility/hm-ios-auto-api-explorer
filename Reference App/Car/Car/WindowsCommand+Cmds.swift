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

    func getWindowsState(failed: @escaping CommandFailed) {
        guard windows.isAvailable else {
            return failed(.needsInitialState)
        }

        let bytes = AAWindows.getWindowsState.bytes

        print("- Car - get windows state")

        sendCommand(bytes, failed: failed)
    }

    func sendWindowsCommand(open: Bool, failed: @escaping CommandFailed) {
        guard self.windows.isAvailable else {
            return failed(.needsInitialState)
        }

        let state: AAPositionState = open ? .open : .closed
        let windows: [AAWindowPosition] = self.windows.windows.map { AAWindowPosition(location: $0.position, position: state) }
        let bytes = AAWindows.controlWindows(openPercentages: nil, positions: windows).bytes

        print("- Car - send windows command, open: \(open)")

        sendCommand(bytes, failed: failed)
    }
}
