//
//  ResponseParser.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


protocol ResponseParser {

    @discardableResult func update(from response: AACapability) -> CommandType?
}
