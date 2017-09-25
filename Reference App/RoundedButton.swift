//
//  RoundedButton.swift
//  Reference App
//
//  Created by Mikk Rätsep on 07/11/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class RoundedButton: UIButton {

    // MARK: Vars

    @IBInspectable var borderColour: UIColor = UIColor.clear {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }


    // MARK: UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius
    }


    // MARK: Private

    private func updateBorder() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColour.cgColor
    }
}
