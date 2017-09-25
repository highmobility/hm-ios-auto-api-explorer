//
//  Double (Degrees-Radians).swift
//  Remote Control
//
//  Created by Mikk Rätsep on 07/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension Double {

    /// Converts from Degrees to Radians
    var radians: Double { return self * Double.pi / 180.0 }

    /// Converts from Radians to Degrees
    var degrees: Double { return self * 180.0 / Double.pi }
}

