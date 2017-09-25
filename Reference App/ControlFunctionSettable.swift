//
//  ControlFunctionSettable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


protocol ControlFunctionSettable {

    associatedtype ControlFunctionType: ControlFunction


    func setControlFunction(_ function: ControlFunctionType)
}
