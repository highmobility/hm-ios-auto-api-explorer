//
//  ArcView.swift
//  Reference App
//
//  Created by Mikk Rätsep on 22/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class ArcView: UIView {

    @IBInspectable var borderColour: UIColor? {
        didSet {
            arcLayer.borderColor = borderColour?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            arcLayer.borderWidth = borderWidth
        }
    }

    var arcLayer = CALayer()


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(arcLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.addSublayer(arcLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        arcLayer.frame = bounds
        arcLayer.cornerRadius = bounds.width / 2.0
    }
}
