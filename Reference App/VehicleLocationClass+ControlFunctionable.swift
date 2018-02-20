//
//  VehicleLocationClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension VehicleLocationClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return { _ in nil }
    }

    var controlFunctions: [ControlFunction] {
        return [FullScreenControlFunction(kind: .vehicleLocation, iconName: "btn_location", viewControllerID: "VehicleLocationViewControllerID")]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
