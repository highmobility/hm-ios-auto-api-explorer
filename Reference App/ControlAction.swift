//
//  ControlAction.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


struct ControlAction {

    typealias Action = (ErrorHandler?) -> Void
    typealias ErrorHandler = (Error) -> Void


    // MARK: Vars

    let name: String
    let iconName: String
    let action: Action


    // MARK: Methods

    func activate(_ errorHandler: ErrorHandler?) {
        action(errorHandler)
    }
}
