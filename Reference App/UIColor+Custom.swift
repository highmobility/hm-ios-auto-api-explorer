//
//  UIColor+Custom.swift
//  Reference App
//
//  Created by Mikk Rätsep on 22/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


extension UIColor {

    enum Custom {

        // These are sRGB values converted to GENERIC RGB
        static let highlight    = UIColor(hexRed: 0xFC, green: 0xDA, blue: 0x35)
        static let pale         = UIColor(hexRed: 0x77, green: 0x7D, blue: 0x88)
        static let lightClay    = UIColor(hexRed: 0x43, green: 0x47, blue: 0x4D)
        static let clay         = UIColor(hexRed: 0x41, green: 0x44, blue: 0x4A)
        static let edge         = UIColor(hexRed: 0x3F, green: 0x42, blue: 0x49)
        static let midClay      = UIColor(hexRed: 0x3A, green: 0x3E, blue: 0x43)
        static let darkClay     = UIColor(hexRed: 0x25, green: 0x27, blue: 0x2B)
        static let nocturne     = UIColor(hexRed: 0x18, green: 0x1A, blue: 0x1C)
    }


    func interpolateRGBColor(to end: UIColor, fraction: CGFloat) -> UIColor? {
        guard (fraction >= 0.0) && (fraction <= 1.0) else {
            return nil
        }

        guard let fromComponents = cgColor.components,
            let endComponents = end.cgColor.components else {
                return nil
        }

        let r: CGFloat = CGFloat(fromComponents[0] + (endComponents[0] - fromComponents[0]) * fraction)
        let g: CGFloat = CGFloat(fromComponents[1] + (endComponents[1] - fromComponents[1]) * fraction)
        let b: CGFloat = CGFloat(fromComponents[2] + (endComponents[2] - fromComponents[2]) * fraction)
        let a: CGFloat = CGFloat(fromComponents[3] + (endComponents[3] - fromComponents[3]) * fraction)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }


    convenience init(hexRed red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat = 1.0) {
        let red     = CGFloat(red) / 255.0
        let green   = CGFloat(green) / 255.0
        let blue    = CGFloat(blue) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
