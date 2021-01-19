//
//  LightsClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension LightsClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            switch $0 {
            case .lightsInterior:
                return self.interiorLightsActive

            case .lightsRear:
                return self.rearLightsActive

            default:
                return nil
            }
        }
    }

    var controlFunctions: [ControlFunction] {
        return [createLightsFront(), createLightsInterior(), createLightsRear()]
    }

    var kinds: [ControlFunction.Kind] {
        return [.lightsFront, .lightsInterior, .lightsRear]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return {
            guard $0 == .lightsFront else {
                return nil
            }

            return "\(self.frontExteriorLightsState)"
        }
    }
}

private extension LightsClass {

    func createLightsFront() -> ControlFunction {
        let firstAction = ControlAction(name: "inactive", iconName: "HeadlightOFF") { errorHandler in
            Car.shared.sendLightsCommand(frontExteriorLights: .inactive) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let secondAction = ControlAction(name: "active", iconName: "HeadlightON") { errorHandler in
            Car.shared.sendLightsCommand(frontExteriorLights: .active) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let thirdAction = ControlAction(name: "full beam", iconName: "FullbeamON") { errorHandler in
            Car.shared.sendLightsCommand(frontExteriorLights: .fullBeam) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return TripleControlFunction(kind: .lightsFront,
                                     firstActionValueTuple: (firstAction, "\(LightsClass.FrontExteriorLightState.inactive)"),
                                     secondActionValueTuple: (secondAction, "\(LightsClass.FrontExteriorLightState.active)"),
                                     thirdActionValueTuple: (thirdAction, "\(LightsClass.FrontExteriorLightState.fullBeam)"))
    }

    func createLightsInterior() -> ControlFunction {
        let mainAction = ControlAction(name: "active", iconName: "InteriorlightON") { errorHandler in
            Car.shared.sendLightsCommand(interiorLightsActive: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "inactive", iconName: "InteriorlightOFF") { errorHandler in
            Car.shared.sendLightsCommand(interiorLightsActive: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .lightsInterior, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }

    func createLightsRear() -> ControlFunction {
        let mainAction = ControlAction(name: "active", iconName: "BacklightON") { errorHandler in
            Car.shared.sendLightsCommand(rearLightsActive: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "inactive", iconName: "BacklightOFF") { errorHandler in
            Car.shared.sendLightsCommand(rearLightsActive: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return DualControlFunction(kind: .lightsRear, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: true)
    }
}
