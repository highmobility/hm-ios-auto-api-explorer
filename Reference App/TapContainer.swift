//
//  TapContainer.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 07/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import UIKit


protocol TapContainerDelegate {
    func tapContainer(tappedDot index: Int, isForward: Bool)
    func tapContainerTappedStop()
}

@IBDesignable class TapContainer: UIView {

    // MARK: Constants

    private struct Constants {

        /// The number of dots for 1 side.
        static let arcTotalDots         = 3

        /// The size of one side's arc for the dots.
        ///
        /// Side's leftmost dot sits from Y-axis *(arcTotalDegrees / 2.0)°* to the left – when looking at the side from the center of this view.
        /// Obviously the rightmost dot then sits the same amount to the right from the Y-axis.
        static let arcTotalDegrees      = 100.0

        /// The allowed arc in which a tap is recognised.
        ///
        /// This configures only 1 side (the same value is for both the front and back sides).
        /// Currently, it's set to allow taps from the side-dots outward of upto ½ the degrees between the dots (of the same side).
        static let arcTapActiveDegrees  = Constants.arcTotalDegrees * max(1, Double(Constants.arcTotalDots)) / max(Double(Constants.arcTotalDots - 1), 1.0)

        /// The allowed radius in which a tap is recognised.
        ///
        /// Obviously starts from the *min* and ends with the *max* radius. Taps outside these boundries are ignored.
        static let dotTapActiveDistance = (min: 50.0, max: 300.0)

        /// The allowed radius for where a *stop* tap is recongised.
        static let stopTapDistance      = min(Constants.dotTapActiveDistance.min, 75.0)
    }

    private struct DotInfo {
        let dot: DotView
        let index: Int
        let isForward: Bool
    }


    // MARK: Variables

    var delegate: TapContainerDelegate?
    var oneSideDotsCount: Int { return Constants.arcTotalDots }

    private var forwardDots: [DotView] = []
    private var backwardDots: [DotView] = []


    // MARK: Gesture Recogniser

    @objc func tapGestureRecognised(_ gestureRec: UITapGestureRecognizer) {
        let tapPoint = gestureRec.location(in: self)

        if center.distance(fromPoint: tapPoint) < CGFloat(Constants.stopTapDistance) {
            delegate?.tapContainerTappedStop()
        }
        else {
            guard center.degreesFromYAxis(toPoint: tapPoint) < (Constants.arcTapActiveDegrees / 2.0)    else { return }
            guard center.distance(fromPoint: tapPoint) > CGFloat(Constants.dotTapActiveDistance.min)    else { return }
            guard center.distance(fromPoint: tapPoint) < CGFloat(Constants.dotTapActiveDistance.max)    else { return }

            let dotInfo = findClosestDotIndex(withPoint: tapPoint)

            dotInfo.dot.animate()

            // Finally send the info to the delegate
            delegate?.tapContainer(tappedDot: dotInfo.index, isForward: dotInfo.isForward)
        }
    }


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        forwardDots     = createDots(forOneSide: Constants.arcTotalDots, isForwardDirection: true)
        backwardDots    = createDots(forOneSide: Constants.arcTotalDots, isForwardDirection: false)

        createGestureRecogniser()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        forwardDots     = createDots(forOneSide: Constants.arcTotalDots, isForwardDirection: true)
        backwardDots    = createDots(forOneSide: Constants.arcTotalDots, isForwardDirection: false)

        createGestureRecogniser()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Move the dots to the right position (without intrinsic animations)
        UIView.performWithoutAnimation {
            forwardDots.forEach  { $0.realPosition = bounds.middlePoint.combine(withPoint: $0.relativePosition) }
            backwardDots.forEach { $0.realPosition = bounds.middlePoint.combine(withPoint: $0.relativePosition) }
        }
    }


    // MARK: Private

    private func createDots(forOneSide count: Int, isForwardDirection: Bool) -> [DotView] {
        let separationDegrees   = Constants.arcTotalDegrees / Double(count - 1)
        var dots: [DotView]     = []

        // Start with the correct side and from the left (when looking at the side from the center)
        var currentDegrees = (isForwardDirection ? -90.0 : 90.0) - (Constants.arcTotalDegrees / 2.0)

        // Create the number of dots and add them to the view
        for _ in 0..<count {
            let relativePosition    = CGPoint(radian: currentDegrees.radians, radius: Double(bounds.width / 4.0 * 1.5))
            let dot                 = DotView(defaultSizeWithRelativePosition: relativePosition)

            dots.append(dot)
            addSubview(dot)

            currentDegrees += separationDegrees
        }

        return dots
    }

    private func createGestureRecogniser() {
        // Create the tap recogniser for the dots (and, as a result, for movement as well)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognised(_:))))
    }

    private func findClosestDotIndex(withPoint point: CGPoint) -> DotInfo {
        var closestDistance = CGFloat.greatestFiniteMagnitude
        var dotInfo: DotInfo!

        // Function that checks if a given dot is closer to the point than another one (the 1st dot will be the closest no matter what)
        func checkIsClosest(idx: Int, dot: DotView, isForward: Bool) {
            let distance = dot.center.distance(fromPoint: point)

            if distance < closestDistance {
                closestDistance = distance
                dotInfo         = DotInfo(dot: dot, index: idx, isForward: isForward)
            }
        }

        forwardDots.enumerated().forEach    { checkIsClosest(idx: $0, dot: $1, isForward: true) }
        backwardDots.enumerated().forEach   { checkIsClosest(idx: $0, dot: $1, isForward: false) }

        return dotInfo
    }
}

