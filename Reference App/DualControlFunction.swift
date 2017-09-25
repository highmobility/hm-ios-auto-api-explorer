//
//  DualControlFunction.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


class DualControlFunction: ControlFunction {

    typealias ErrorHandler = ControlAction.ErrorHandler


    // MARK: Vars

    let mainAction: ControlAction
    let oppositeAction: ControlAction

    private let isMainActionStatusTrue: Bool

    private(set) var isMainActionActive: Bool = true

    var activeIconName: String {
        return isMainActionActive ? mainAction.iconName : oppositeAction.iconName
    }


    // MARK: Methods

    func activateOther(_ errorHandler: ErrorHandler?) {
        if isMainActionActive {
            oppositeAction.activate(errorHandler)
        }
        else {
            mainAction.activate(errorHandler)
        }
    }

    override func receivedUpdate(_ command: Command) {
        super.receivedUpdate(command)

        guard let thingy = command as? ControlFunctionable else {
            return
        }

        guard let statusValue = thingy.boolValue(kind) else {
            return
        }

        // I'm sure there's a PROPER operant for this, but idk...
        isMainActionActive = isMainActionStatusTrue ? statusValue : !statusValue
    }


    // MARK: Initialiser

    init(kind: Kind, mainAction: ControlAction, oppositeAction: ControlAction, isMainTrue: Bool) {
        self.mainAction = mainAction
        self.oppositeAction = oppositeAction

        self.isMainActionStatusTrue = isMainTrue
        
        super.init(kind: kind)
    }
}
