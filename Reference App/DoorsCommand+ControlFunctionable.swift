//
//  DoorsClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension DoorsCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .doorsLock else {
                return nil
            }

            return self.locked
        }
    }

    var controlFunctions: [ControlFunction] {
        return [createLockUnlock(), createShowStatus()]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}

private extension DoorsCommand {

    func createLockUnlock() -> DualControlFunction {
        let mainAction = ControlAction(name: "unlocked", iconName: "DoorlockUNLOCKED") { errorHandler in
            Car.shared.sendDoorsCommand(lock: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "locked", iconName: "DoorlockLOCKED") { errorHandler in
            Car.shared.sendDoorsCommand(lock: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .doorsLock, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: false)
    }

    func createShowStatus() -> FullScreenControlFunction {
        return FullScreenControlFunction(kind: .doorsStatus, iconName: "DoorlockLOCKED", viewControllerID: "DoorsStatusViewControllerID")
    }
}
