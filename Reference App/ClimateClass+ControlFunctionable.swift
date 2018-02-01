//
//  ClimateClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension ClimateClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            switch $0 {
            case .hvac:
                return self.hvacActive

            case .windshieldHeating:
                return self.windshieldDefrosting

            default:
                return nil
            }
        }
    }

    var controlFunctions: [ControlFunction] {
        return [createHVAC(), createWindshieldDefrosting()]
    }

    var kinds: [ControlFunction.Kind] {
        return [.hvac, .windshieldHeating]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}

private extension ClimateClass {

    func createHVAC() -> DualControlFunction {
        let mainAction = ControlAction(name: "active", iconName: "HVAC_ON") { errorHandler in
            Car.shared.sendHVACCommand(activate: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "inactive", iconName: "HVAC_OFF") { errorHandler in
            Car.shared.sendHVACCommand(activate: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .hvac, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }

    func createWindshieldDefrosting() -> DualControlFunction {
        let mainAction = ControlAction(name: "active", iconName: "WindscreenHeatingON") { errorHandler in
            Car.shared.sendWindshieldDefrostingCommand(defrosting: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "inactive", iconName: "WindscreenHeatingOFF") { errorHandler in
            Car.shared.sendWindshieldDefrostingCommand(defrosting: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .windshieldHeating, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }
}
