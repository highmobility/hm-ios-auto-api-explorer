//
//  RoundedImageButton.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 13/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class RoundedImageButton: ImageButton {

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
