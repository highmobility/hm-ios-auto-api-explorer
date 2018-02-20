//
//  ParkingBrakeCommand+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension ParkingBrakeCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .parkingBrake else {
                return nil
            }

            return self.isActive
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "active", iconName: "btn_parking-brake_on") { errorHandler in
            Car.shared.sendParkingBrake(activate: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "inactive", iconName: "btn_parking-brake_off") { errorHandler in
            Car.shared.sendParkingBrake(activate: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .parkingBrake, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.parkingBrake]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
