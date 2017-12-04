//
//  String+Hex.swift
//  Network
//
//  Created by Mikk Rätsep on 06/01/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension String {

    var characterPairs: [String] {
        let startEmptyStringPairsArray: [String] = []

        return enumerated().reduce(startEmptyStringPairsArray) { (midResult, enumerationTuple) in
            var result = midResult

            if (enumerationTuple.offset % 2) == 1 {
                result[result.endIndex - 1] = midResult.last! + enumerationTuple.element.description
            }
            else {
                result.append(enumerationTuple.element.description)
            }

            return result
        }
    }

    var nsString: NSString {
        return self as NSString
    }
}

extension String: UInt8CollectionConvertible {

    var bytes: [UInt8] {
        return characterPairs.flatMap { UInt8($0, radix: 16) }
    }

    var data: Data {
        return Data(bytes: bytes)
    }

    var hex: String {
        return bytes.map { String(format: "%02X", $0) }.joined()
    }
}
