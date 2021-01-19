//
//  EngineClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension EngineClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .engine else {
                return nil
            }

            return self.on
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "on", iconName: "EngineON") { errorHandler in
            Car.shared.sendEngineCommand(on: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "off", iconName: "EngineOFF") { errorHandler in
            Car.shared.sendEngineCommand(on: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .engine, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.engine]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
