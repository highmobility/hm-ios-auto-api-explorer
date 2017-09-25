//
//  RoundedView.swift
//  Reference App
//
//  Created by Mikk Rätsep on 02/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class RoundedView: UIView {

    // MARK: Vars

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
}
