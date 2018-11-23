//
//  CapabilityParser.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


protocol CapabilityParser {

    func update(from capability: AACapability)
}
