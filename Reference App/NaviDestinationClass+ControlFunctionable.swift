//
//  NaviDestinationClass+ControlFunctionable.swift
//  The App
//
//  Created by Mikk Rätsep on 29/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension NaviDestinationClass: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return { _ in nil }
    }

    var controlFunctions: [ControlFunction] {
        return [FullScreenControlFunction(kind: .naviDestination, iconName: "btn_navi-destination", viewControllerID: "NaviDestinationViewControllerID")]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
