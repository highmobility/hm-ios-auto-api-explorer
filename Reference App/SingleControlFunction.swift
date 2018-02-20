//
//  SingleControlFunction.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Foundation


class SingleControlFunction: ControlFunction {

    typealias ErrorHandler = ControlAction.ErrorHandler


    // MARK: Vars

    let action: ControlAction

    var iconName: String {
        return action.iconName
    }


    // MARK: Methods

    func activate(_ errorHandler: ErrorHandler?) {
        action.activate(errorHandler)
    }


    // MARK: Init

    init(kind: Kind, action: ControlAction) {
        self.action = action

        super.init(kind: kind)
    }
}
