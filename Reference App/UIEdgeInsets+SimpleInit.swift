//
//  UIEdgeInsets+SimpleInit.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 02/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


extension UIEdgeInsets {

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
