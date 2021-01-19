//
//  TitlesScrollViewContainer.swift
//  Reference App
//
//  Created by Mikk Rätsep on 12/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class TitlesScrollViewContainer: UIView {

    private var scrollView: TitlesScrollView!


    // MARK: UIView

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        if let scrollView = subview as? TitlesScrollView {
            self.scrollView = scrollView
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.point(inside: point, with: event) ? scrollView : nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTapRecogniser()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addTapRecogniser()
    }

    // MARK: Methods

    @objc func tapRecognised(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: self)

        guard !scrollView.frame.contains(touchPoint) else {
            return
        }

        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        let newIndex: CGFloat

        // Find the new index
        if touchPoint.x < scrollView.frame.midX {
            newIndex = max(0.0, round(currentIndex - 1.0))
        }
        else {
            let maxIdx = (scrollView.contentSize.width / scrollView.bounds.width) - 1.0

            newIndex = min(maxIdx, round(currentIndex + 1.0))
        }

        // Update the scrollViews
        scrollView.setContentOffset(CGPoint(x: (newIndex * scrollView.bounds.width), y: 0.0), animated: true)
    }

    private func addTapRecogniser() {
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(tapRecognised(_:)))
        
        addGestureRecognizer(gestureRec)
    }
}
