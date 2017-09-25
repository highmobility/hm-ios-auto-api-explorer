//
//  UInt8CollectionConvertible.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 19/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


typealias BytesConvertible = UInt8CollectionConvertible

typealias DataConvertible = UInt8CollectionConvertible

typealias HexConvertible = UInt8CollectionConvertible


protocol UInt8CollectionConvertible {

    var bytes: [UInt8] { get }

    var data: Data { get }

    var hex: String { get }
}
