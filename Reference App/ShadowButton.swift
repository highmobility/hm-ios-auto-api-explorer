//
//  ShadowButton.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 07/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class ShadowButton: UIButton {

    @IBInspectable var shadowColour: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColour.cgColor
        }
    }

    @IBInspectable var shadowOpacity: CGFloat = 1.0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 5.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureShadow()
    }
}

private extension ShadowButton {

    func configureShadow() {
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius
    }
}
