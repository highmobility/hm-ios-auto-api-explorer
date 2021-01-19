//
//  ShadowView.swift
//  Reference App
//
//  Created by Mikk Rätsep on 22/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class ShadowView: RoundedView {

    @IBInspectable var shadowColour: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColour.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
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

private extension ShadowView {

    func configureShadow() {
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = backgroundColor?.cgColor
    }
}
