//
//  TitlesScrollView.swift
//  Reference App
//
//  Created by Mikk Rätsep on 11/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class TitlesScrollView: UIScrollView {

    // MARK: Vars

    var didScrollWithIndexProgress: ((CGFloat) -> Void)?

    var titles: [String] = [] {
        didSet {
            removeAllTitles()
            createNewTitles()
        }
    }

    private var isAnimating: Bool = false
    private var labels: [UILabel] = []


    // MARK: Methods

    func setIndexProgress(_ progress: CGFloat) {
        changeLabelsColour(progress: progress)

        contentOffset.x = bounds.width * progress
    }


    // MARK: UIScrollView

    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        isAnimating = animated

        super.setContentOffset(contentOffset, animated: animated)
    }


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Labels could've been initialised with a 0 height (if they were created in the GRID mode, where this view's height is 0)
        guard labels.first?.bounds.height != bounds.height else {
            return
        }

        labels.forEach {
            $0.frame.origin.y = 0.0
            $0.frame.size.height = self.bounds.height
        }
    }
}

extension TitlesScrollView: UIScrollViewDelegate {

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isAnimating = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging || scrollView.isDecelerating || isAnimating else {
            return
        }

        let progress = scrollView.contentOffset.x / bounds.width

        changeLabelsColour(progress: progress)
        didScrollWithIndexProgress?(progress)
    }
}

private extension TitlesScrollView {

    // MARK: Beauty

    func changeLabelsColour(progress: CGFloat) {
        let idx = Int(progress.rounded(.down))

        // Change the "left" label
        if idx >= labels.startIndex {
            let diff = fabs(progress - CGFloat(idx))

            labels[idx].textColor = UIColor.Custom.highlight.interpolateRGBColor(to: UIColor.Custom.pale, fraction: diff)
        }

        // Change the "right" label
        if (idx + 1) < labels.endIndex {
            let diff = fabs(CGFloat(idx + 1) - progress)

            labels[idx + 1].textColor = UIColor.Custom.highlight.interpolateRGBColor(to: UIColor.Custom.pale, fraction: diff)
        }

        // Reset the other closes ones too... (helps with jump-updates)
        if (idx - 1) >= labels.startIndex {
            labels[idx - 1].textColor = UIColor.Custom.pale
        }

        if (idx + 2) < labels.endIndex {
            labels[idx + 2].textColor = UIColor.Custom.pale
        }
    }


    // MARK: Labels

    func titleLabelAddedToView(_ title: String) -> UILabel {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: bounds.size))

        label.textAlignment = .center
        label.textColor = UIColor(hexRed: 0x8A, green: 0x90, blue: 0x9A, alpha: 1.0)
        label.text = title.uppercased()
        label.font = UIFont.systemFont(ofSize: 14.0)

        addSubview(label)

        return label
    }


    // MARK: Titles

    func createNewTitles() {
        var xxx: CGFloat = 0.0

        // Loop through the titles and add labels to scrollView
        titles.enumerated().forEach {
            let label = titleLabelAddedToView($0.element)

            // Configure the label's location
            label.frame.origin.x = xxx

            // Increase the x-coordinate for the next one
            xxx += bounds.width

            // Need to keep a reference to the labels
            labels.append(label)
        }

        // Update the scrollView's contentSize (so it actually scrolls)
        contentSize.width = xxx

        // Set the 1st label to be higlighted
        labels.first?.textColor = UIColor.Custom.highlight
    }

    func removeAllTitles() {
        labels.removeAll()

        subviews.forEach { $0.removeFromSuperview() }
    }
}
