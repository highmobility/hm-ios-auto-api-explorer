//
//  CGRect.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 07/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


extension CGRect {

    /// The center of the rectangle.
    var middlePoint: CGPoint {
        return CGPoint(x: (width / 2.0), y: (height / 2.0))
    }


    func translated(by translation: CGPoint) -> CGRect {
        return CGRect(origin: CGPoint(x: (origin.x + translation.x), y: (origin.y + translation.y)), size: size)
    }

    mutating func translate(by translation: CGPoint) {
        origin.x += translation.x
        origin.y += translation.y
    }
}
