//
//  ControlFunction+Trunk.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension Trunk: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .trunkAccess else {
                return nil
            }

            return self.locked
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "unlocked", iconName: "TrunkOPEN") { errorHandler in
            Car.shared.sendTrunkCommand(lock: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "locked", iconName: "TrunkCLOSED") { errorHandler in
            Car.shared.sendTrunkCommand(lock: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .trunkAccess, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: false)]
    }

    var kinds: [ControlFunction.Kind] {
        return [.trunkAccess]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
