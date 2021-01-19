//
//  AASupportedCapability+Extensions.swift
//  Car
//
//  Created by Mikk Rätsep on 10.01.20.
//  Copyright © 2020 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


extension AASupportedCapability {

    public func supports(propertyIDs: UInt8...) -> Bool {
        Set(supportedPropertyIDs).isSuperset(of: propertyIDs)
    }

    public func supportsAllProperties<C: CaseIterable & RawRepresentable>(for capability: C.Type) -> Bool where C.RawValue == UInt8 {
        Set(supportedPropertyIDs) == Set(capability.allCases.map { $0.rawValue })
    }
}
