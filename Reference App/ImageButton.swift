//
//  ImageButton.swift
//  Reference App
//
//  Created by Mikk Rätsep on 10/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class ImageButton: UIButton {

    // MARK: IBInspectables

    @IBInspectable var imageInset: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var imageSpacing: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var isImageLeading: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var isImageTrailing: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var isTextCentered: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }


    // MARK: UIButton

    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        var contentRect = super.contentRect(forBounds: bounds)
        let imageWidth = super.imageRect(forContentRect: contentRect).width
        let titleWidth = super.titleRect(forContentRect: contentRect).width

        if !isImageTrailing || isImageLeading {
            contentRect.size = CGSize(width: (imageWidth + titleWidth + imageSpacing), height: contentRect.height)
        }

        return contentRect
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleRect = super.titleRect(forContentRect: contentRect)

        if isTextCentered {
            titleRect.origin.x = bounds.midX - (titleRect.width / 2.0)
        }
        else {
            if isImageLeading {
                let imageWidth = super.imageRect(forContentRect: contentRect).width

                titleRect.origin.x = imageWidth + imageSpacing
            }
            else {
                titleRect.origin.x = 0.0
            }
        }

        return titleRect
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageRect = super.imageRect(forContentRect: contentRect)

        if isImageTrailing {
            imageRect.origin.x = contentRect.width - imageRect.width - imageSpacing
        }
        else if isImageLeading {
            imageRect.origin.x = 0.0
        }
        else {
            if titleLabel?.text == nil {
                imageRect.origin.x = bounds.midX - (imageRect.width / 2.0)
            }
            else {
                let titleRect = self.titleRect(forContentRect: contentRect)

                imageRect.origin.x = titleRect.maxX + imageSpacing
            }
        }

        return imageRect.insetBy(dx: imageInset, dy: (imageInset * (imageRect.height / imageRect.width)))
    }
}
