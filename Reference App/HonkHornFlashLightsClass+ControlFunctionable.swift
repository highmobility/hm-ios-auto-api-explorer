//
//  HonkHornFlashLightsClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension HonkHornFlashLightsClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            switch $0 {
            case .emergencyFlasher:
                return self.emergencyFlasherOn

            case .honkFlash:
                return true

            default:
                return nil
            }
        }
    }

    var controlFunctions: [ControlFunction] {
        return [createEmergerncyFlasher(), createHonkFlash()]
    }

    var kinds: [ControlFunction.Kind] {
        return [.emergencyFlasher, .honkFlash]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}

private extension HonkHornFlashLightsClass {

    func createEmergerncyFlasher() -> DualControlFunction {
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

        return DualControlFunction(kind: .emergencyFlasher, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }

    func createHonkFlash() -> SingleControlFunction {
        let action = ControlAction(name: "honk 1s and flash once", iconName: "btn_honk-lights") { errorHandler in
            Car.shared.sendHonkHornFlashLightsOnce() {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return SingleControlFunction(kind: .honkFlash, action: action)
    }
}
