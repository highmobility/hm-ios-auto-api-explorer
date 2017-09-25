//
//  TripleControlFunction.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 05/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import Foundation


class TripleControlFunction: ControlFunction {

    typealias ActionValueTuple = (ControlAction, String)
    typealias ErrorHandler = ControlAction.ErrorHandler


    // MARK: Vars

    private let firstTuple: ActionValueTuple
    private let secondTuple: ActionValueTuple
    private let thirdTuple: ActionValueTuple

    private(set) var activeActionIndex: Int = -1

    var firstAction: ControlAction {
        return firstTuple.0
    }

    var secondAction: ControlAction {
        return secondTuple.0
    }

    var thirdAction: ControlAction {
        return thirdTuple.0
    }

    var activeIconName: String {
        if activeActionIndex == 0 {
            return firstAction.iconName
        }
        else if activeActionIndex == 1 {
            return secondAction.iconName
        }
        else {
            return thirdAction.iconName
        }
    }


    // MARK: Methods

    func activateNext(_ errorHandler: ErrorHandler?) {
        if activeActionIndex == 0 {
            secondAction.activate(errorHandler)
        }
        else if activeActionIndex == 1 {
            thirdAction.activate(errorHandler)
        }
        else {
            firstAction.activate(errorHandler)
        }
    }

    func activatePrevious(_ errorHandler: ErrorHandler?) {
        if activeActionIndex == 0 {
            thirdAction.activate(errorHandler)
        }
        else if activeActionIndex == 1 {
            firstAction.activate(errorHandler)
        }
        else {
            secondAction.activate(errorHandler)
        }
    }

    override func receivedUpdate(_ command: Command) {
        super.receivedUpdate(command)

        guard let thingy = command as? ControlFunctionable else {
            return
        }

        guard let stringValue = thingy.stringValue(kind) else {
            return
        }

        switch stringValue {
        case firstTuple.1:
            activeActionIndex = 0

        case secondTuple.1:
            activeActionIndex = 1

        case thirdTuple.1:
            activeActionIndex = 2

        default:
            return
        }
    }


    // MARK: Initialiser

    init(kind: Kind, firstActionValueTuple: ActionValueTuple, secondActionValueTuple: ActionValueTuple, thirdActionValueTuple: ActionValueTuple) {
        self.firstTuple = firstActionValueTuple
        self.secondTuple = secondActionValueTuple
        self.thirdTuple = thirdActionValueTuple

        super.init(kind: kind)
    }
}
