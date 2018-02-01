//
//  RooftopClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


extension RooftopClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            switch $0 {
            case .rooftopDimming:
                return self.dimmed

            case .rooftopOpening:
                return self.open

            default:
                return nil
            }
        }
    }

    var controlFunctions: [ControlFunction] {
        return [createRooftopDimming(), createRooftopOpening()]
    }

    var kinds: [ControlFunction.Kind] {
        return [.rooftopDimming, .rooftopOpening]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}

private extension RooftopClass {

    func createRooftopDimming() -> ControlFunction {
        let mainAction = ControlAction(name: "opaque", iconName: "SunroofOPAQUE") { errorHandler in
            Car.shared.sendRooftopCommand(dimmed: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "transparent", iconName: "SunroofTRANSPARENT") { errorHandler in
            Car.shared.sendRooftopCommand(dimmed: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .rooftopDimming, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }

    func createRooftopOpening() -> ControlFunction {
        let mainAction = ControlAction(name: "open", iconName: "RooftopOPEN") { errorHandler in
            Car.shared.sendRooftopCommand(open: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "close", iconName: "RooftopCLOSED") { errorHandler in
            Car.shared.sendRooftopCommand(open: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .rooftopOpening, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }
}
