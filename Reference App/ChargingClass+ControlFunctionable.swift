//
//  ChargingClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 21/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension ChargingClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .charging else {
                return nil
            }

            return self.charging
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "start", iconName: "BatteryCHARGING") { errorHandler in
            Car.shared.sendChargingCommand(start: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "stop", iconName: "BatteryNOTCHARGING") { errorHandler in
            Car.shared.sendChargingCommand(start: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .charging, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.charging]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
