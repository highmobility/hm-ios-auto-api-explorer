//
//  HashableEmpty.swift
//  Car
//
//  Created by Mikk Rätsep on 10/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


protocol HashableEmpty: Hashable {

}

extension HashableEmpty {

    var hashValue: Int {
        return "\(type(of: self))".hashValue
    }


    static func ==(lhs: Self, rhs: Self) -> Bool {
        return true
    }
}
