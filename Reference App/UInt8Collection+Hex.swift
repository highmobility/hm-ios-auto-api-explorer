//
//  UInt8Collection+Hex.swift
//  Reference App
//
//  Created by Mikk Rätsep on 10/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension Collection where Iterator.Element == UInt8, Self: UInt8CollectionConvertible {

    var bytes: [UInt8] {
        return Array(self)
    }

    var data: Data {
        return Data(bytes)
    }

    var hex: String {
        return map { String(format: "%02X", $0) }.joined()
    }
}
