//
//  PanningScrollView.swift
//  Reference App
//
//  Created by Mikk Rätsep on 11/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class PanningScrollView: UIScrollView {

    var titles: [String] = [] {
        didSet {
            removeAllTitles()
            createNewTitles()
        }
    }

    fileprivate var titleLabels: [UILabel] = []


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = self
    }
}

extension PanningScrollView: UIScrollViewDelegate {

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let centerSubtraction = scrollView.contentOffset.x + (scrollView.bounds.width / 2.0)
//
//        guard let closestLabel = titleLabels.min(by: { fabs($0.0.center.x - centerSubtraction) < fabs($0.1.center.x - centerSubtraction) }) else {
//            return
//        }
//
//        guard let index = titleLabels.index(of: closestLabel) else {
//            return
//        }
//
//        // Find the target label
//        let targetLabel: UILabel
//        let threshold: CGFloat = 0.5
//
//        switch (velocity.x, index) {
//        // If moving to the RIGHT with some speed and it's not the LAST one
//        case let (vel, idx) where (vel > threshold) && (titleLabels.index(after: idx) < titleLabels.endIndex):
//            targetLabel = titleLabels[titleLabels.index(after: idx)]
//
//        // If moving to the LEFT with some speed and it's not the FIRST one
//        case let (vel, idx) where (vel < -threshold) && (titleLabels.index(before: idx) > (titleLabels.startIndex - 1)):
//            targetLabel = titleLabels[titleLabels.index(before: idx)]
//
//        default:
//            targetLabel = closestLabel
//        }
//
//        print("velocity: \(velocity.x), index: \(index) - \(titleLabels[index].text!), closest: \(closestLabel.text!), target: \(targetLabel.text!)")
//
//        // Set the target offset to the label's
//        targetContentOffset.pointee.x = targetLabel.center.x - (scrollView.bounds.width / 2.0)
//    }
}

fileprivate extension PanningScrollView {

    var dashGapSize: CGFloat { return 30.0 }


    // MARK: Labels

    func titleLabelAddedToView(_ title: String) -> UILabel {
        let label = UILabel()

        label.textColor = UIColor(hexString: "#8A909A")
        label.text = title.uppercased()
        label.sizeToFit()

        addSubview(label)

        return label
    }

    func dashLabelAddedToView() -> UILabel {
        return titleLabelAddedToView("-")
    }


    // MARK: Titles

    func createNewTitles() {
        var centerX = bounds.midX

        // Enumarate through the titles
        titles.enumerated().forEach {
            let label = titleLabelAddedToView($0.element)

            titleLabels.append(label)

            // Move the centerX half way forward after the 1st title
            if $0.offset > 0 {
                centerX += label.bounds.width / 2.0
            }

            // Center the label
            label.center = CGPoint(x: centerX, y: bounds.midY)

            // Add a dash between titles
            if $0.offset < (titles.count - 1) {
                // Increase the centerX by half of the latest label (and dashGap)
                centerX += label.bounds.width / 2.0
                centerX += dashGapSize

                // Create the dash and set it's center
                dashLabelAddedToView().center = CGPoint(x: centerX, y: bounds.midY)

                // Increase the centerX further
                centerX += dashGapSize
            }
        }

        // Update the scrollView's contentSize (so it actually scrolls)
        contentSize.width = centerX + bounds.midX
    }
    
    func removeAllTitles() {
        titleLabels.removeAll()

        subviews.forEach { $0.removeFromSuperview() }
    }
}
