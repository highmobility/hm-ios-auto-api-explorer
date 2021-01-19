//
//  RemoteControlClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension RemoteControlClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return { _ in nil }
    }

    var controlFunctions: [ControlFunction] {
        return [FullScreenControlFunction(kind: .remoteControl, iconName: "Remote", viewControllerID: "RemoteControlViewControllerID")]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return {
            guard $0 == .remoteControl else {
                return nil
            }

            return "\(self.controlMode)"
        }
    }
}
