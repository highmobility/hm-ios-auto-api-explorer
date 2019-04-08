//
//  MarkDotView.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 07/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


@IBDesignable class DotView: UIView {

    private struct Constants {
        static let colour       = #colorLiteral(red: 0.9959933162, green: 0.8740460277, blue: 0.3276060522, alpha: 1)

        static let dotSize      = 7.0

        static let borderWidth  = CGFloat(2.0)
        static let borderSize   = CGFloat(20.0)

        static let animScale    = CGFloat(3.0)
        static let animDuration = 0.2
    }


    // MARK: Variables

    var relativePosition    = CGPoint.zero
    var realPosition        = CGPoint.zero { didSet { center = realPosition } }

    private var border: CALayer!


    // MARK: Public Methods

    func animate() {
        let scaleAnimation  = CABasicAnimation(keyPath: "transform")
        let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
        let animationGroup  = CAAnimationGroup()

        scaleAnimation.toValue  = NSValue(caTransform3D: CATransform3DMakeScale(Constants.animScale, Constants.animScale, 1.0))
        borderAnimation.toValue = Constants.borderWidth / Constants.animScale

        animationGroup.autoreverses     = true
        animationGroup.duration         = Constants.animDuration
        animationGroup.timingFunction   = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animationGroup.animations       = [scaleAnimation, borderAnimation]

        border.add(animationGroup, forKey: nil)
    }


    // MARK: Convenience Initialiser

    convenience init(defaultSizeWithRelativePosition position: CGPoint) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Constants.dotSize, height: Constants.dotSize)))

        relativePosition = position
    }


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        createBorder()
        setDotAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        createBorder()
        setDotAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Updates the cornerRadius after the layout (size) has changed
        layer.cornerRadius = min(bounds.midX, bounds.midY)

        // Move the border to the correct position
        border.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }


    // MARK: Private

    private func createBorder() {
        border              = CALayer()
        border.bounds       = CGRect(origin: CGPoint.zero, size: CGSize(width: Constants.borderSize, height: Constants.borderSize))
        border.cornerRadius = Constants.borderSize / 2.0
        border.borderWidth  = Constants.borderWidth
        border.borderColor  = Constants.colour.cgColor

        layer.addSublayer(border)
    }

    private func setDotAppearance() {
        backgroundColor = Constants.colour
    }
}

