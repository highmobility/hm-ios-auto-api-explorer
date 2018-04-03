//
//  VehicleStatusParser.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


protocol VehicleStatusParser {

    @discardableResult func update(from response: Command) -> CommandType?
}
