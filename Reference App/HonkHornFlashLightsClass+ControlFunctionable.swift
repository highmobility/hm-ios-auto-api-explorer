//
//  HonkHornFlashLightsClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension HonkHornFlashLightsClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .emergencyFlasher else {
                return nil
            }

            return self.emergencyFlasherOn
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "activate", iconName: "FlashON") { errorHandler in
            Car.shared.sendEmergencyFlasherCommand(activate: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "deactivate", iconName: "FlashOFF") { errorHandler in
            Car.shared.sendEmergencyFlasherCommand(activate: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .emergencyFlasher, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.emergencyFlasher]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
