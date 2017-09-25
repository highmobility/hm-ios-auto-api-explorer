//
//  OvalButton.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 12/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class OvalButton: UIButton {

    // MARK: UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        // Updates the cornerRadius after the layout (size) has changed
        layer.cornerRadius = min(bounds.midX, bounds.midY)
    }
}

