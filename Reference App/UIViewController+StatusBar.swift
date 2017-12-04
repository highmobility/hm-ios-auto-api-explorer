//
//  UIViewController+StatusBar.swift
//  The App
//
//  Created by Mikk Rätsep on 23/08/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


extension UIViewController {

    private enum Constants {
        static let animationDuration: Double = 0.25
    }


    func clearStatusBarInfo() {
        fadeOut(duration: Constants.animationDuration)
    }

    func displayStatusBarInfo(_ text: String?, for seconds: Double = 3.0, isPermanent: Bool = false, completion: (() -> Void)?) {
        guard let text = text, text.count > 0 else {
            return fadeOut(duration: Constants.animationDuration)
        }

        infoLabel.text = text

        fadeInIfNecessary(duration: Constants.animationDuration)
        matchNavigationBarColour()

        // If the info is meant to be permanent – do nothing else
        guard !isPermanent else {
            return
        }

        // Otherwise wait for X-seconds
        delay(seconds) {
            // And check if the text is still old one (the one wanting to be cleared)
            guard self.infoLabel.text == text else {
                return
            }

            self.fadeOut(duration: Constants.animationDuration)

            completion?()
        }
    }
}

private extension UIViewController {

    private static var strongWindow: UIWindow?  // Needs to keep a strong reference to the window


    // MARK: Computed Vars

    var infoLabel: UILabel {
        var label: UILabel! = window.subviews.flatMap({ $0 as? UILabel }).first

        // If it exists - return it
        guard label == nil else {
            return label
        }

        // Otherwise create it
        label = UILabel(frame: UIApplication.shared.statusBarFrame.insetBy(dx: 8.0, dy: 0.0))

        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.minimumScaleFactor = 0.85

        label.alpha = 1.0
        label.frame.origin.y = -label.bounds.height

        label.textAlignment = .center
        label.textColor = UIColor.white

        // Add it to the view hierarchy
        window.addSubview(label)

        return label
    }

    var window: UIWindow {
        var window: UIWindow! = UIViewController.strongWindow

        // If it exists - return it
        guard window == nil else {
            return window
        }

        // Otherwise create it
        window = UIWindow(frame: UIApplication.shared.statusBarFrame)

        window.alpha = 0.0
        window.backgroundColor = navigationController?.navigationBar.barTintColor
        window.isHidden = false
        window.windowLevel = UIWindowLevelStatusBar

        // Add it to the strong refenrece variable
        UIViewController.strongWindow = window

        return window
    }


    // MARK: Methods

    func fadeInIfNecessary(duration: Double) {
        guard window.alpha != 1.0 else {
            return
        }

        // Start the window-background first
        UIView.animate(withDuration: duration) {
            self.window.alpha = 1.0
        }

        // And the label slide-in a bit later
        UIView.animate(withDuration: duration, delay: (duration / 5.0), options: [], animations: {
            self.infoLabel.alpha = 1.0
            self.infoLabel.frame.origin.y = 0.0
        }, completion: nil)
    }

    func fadeOut(duration: Double) {
        // Start the label slide-out first
        UIView.animate(withDuration: duration) {
            self.infoLabel.alpha = 0.0
            self.infoLabel.frame.origin.y = -self.infoLabel.bounds.height
        }

        // And the window-background a bit later
        UIView.animate(withDuration: duration, delay: (duration / 5.0), options: [], animations: {
            self.window.alpha = 0.0
        }, completion: nil)
    }

    func matchNavigationBarColour() {
        window.backgroundColor = navigationController?.navigationBar.barTintColor
    }
}
