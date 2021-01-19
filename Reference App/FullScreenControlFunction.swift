//
//  FullScreenControlFunction.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


class FullScreenControlFunction: ControlFunction {

    let iconName: String
    let viewControllerID: String


    init(kind: Kind, iconName: String, viewControllerID: String) {
        self.iconName = iconName
        self.viewControllerID = viewControllerID

        super.init(kind: kind)
    }
}
