//
//  ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


protocol ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? { get }

    var controlFunctions: [ControlFunction] { get }

    var kinds: [ControlFunction.Kind] { get }

    var stringValue: (ControlFunction.Kind) -> String? { get }
}

extension ControlFunctionable {

    var kinds: [ControlFunction.Kind] {
        return controlFunctions.map { $0.kind }
    }
}
