//
//  Delay.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 12/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import Foundation


func delay(_ delay: Double, block: @escaping () -> (Void)) {
    DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + delay), execute: block)
}

