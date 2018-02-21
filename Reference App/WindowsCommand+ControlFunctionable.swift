//
//  WindowsClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension WindowsCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .windows else {
                return nil
            }

            return self.open
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainActions = ControlAction(name: "open", iconName: "WindowDOWN") { errorHandler in
            Car.shared.sendWindowsCommand(open: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "close", iconName: "WindowUP") { errorHandler in
            Car.shared.sendWindowsCommand(open: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .windows, mainAction: mainActions, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}


extension WindowsStatusCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return { _ in nil }
    }

    var controlFunctions: [ControlFunction] {
        return [FullScreenControlFunction(kind: .windowsStatus, iconName: "WindowUP", viewControllerID: "WindowsStatusViewControllerID")]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
