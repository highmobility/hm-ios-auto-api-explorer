//
//  CustomItemSizeFromBounds.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 02/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


protocol CustomItemSizeFromBounds {

    var customItemSizeFromBounds: (CGRect) -> CGSize { get }
}
