//
//  CGPoint.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 07/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


extension CGPoint {

    /// Combines the point with another one.
    ///
    /// - parameter point: The second point to combine the x and y values with.
    ///
    /// - returns: The new combined CGPoint.
    func combine(withPoint point: CGPoint) -> CGPoint {
        return CGPoint(x: (x + point.x), y: (y + point.y))
    }

    /// The distance between two points (using Pythagorean theorem).
    ///
    /// - parameter point: The other point at the end of the "imaginary" line.
    ///
    /// - returns: The distance as a CGFloat.
    func distance(fromPoint point: CGPoint) -> CGFloat {
        return sqrt(pow((x - point.x), 2.0) + pow((y - point.y), 2.0))
    }

    /// The degrees between this point's Y-axis and the given one.
    ///
    /// - parameter point: The other point for the corner.
    ///
    /// - returns: The degrees between the points.
    func degreesFromYAxis(toPoint point: CGPoint) -> Double {
        return Double(atan2(pow((x - point.x), 2.0), pow((y - point.y), 2.0))).degrees
    }

    func offset(by point: CGPoint) -> CGPoint {
        return combine(withPoint: point)
    }

    func withNewX(_ newX: CGFloat) -> CGPoint {
        return CGPoint(x: newX, y: y)
    }

    /// Initialise CGPoint with the angle and the distance.
    ///
    /// - parameter radian: The angle from the fictional center point.
    /// - parameter radius: The distance from the fictional center point.
    ///
    /// - returns: Initialised CGPoint with x and y values set.
    init(radian: CGFloat, radius: CGFloat) {
        x = cos(radian) * radius
        y = sin(radian) * radius
    }

    /// Overloads the init with CGFloats.
    init(radian: Double, radius: Double) {
        self.init(radian: CGFloat(radian), radius: CGFloat(radius))
    }
}

