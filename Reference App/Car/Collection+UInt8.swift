//
//  UInt8+Collection.swift
//  AutoAPI
//
//  Created by Mikk Rätsep on 21/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension Collection where Iterator.Element == UInt8 {

    var bytes: [UInt8] {
        return Array(self)
    }

    var data: Data {
        return Data(bytes)
    }

    var hexString: String {
        return map { String(format: "%02X", $0) }.joined()
    }
}
