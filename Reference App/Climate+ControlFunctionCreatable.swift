//
//  Climate+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension Climate: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .windshieldHeating else {
                return nil
            }

            return self.windshieldDefrosting
        }
    }

    var controlFunctions: [ControlFunction] {
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

        return [DualControlFunction(kind: .windshieldHeating, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.windshieldHeating]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
