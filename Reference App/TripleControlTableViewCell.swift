//
//  TripleControlTableViewCell.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 05/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class TripleControlTableViewCell: ControlTableViewCell {

    private typealias Action = ControlAction.Action
    private typealias ErrorHandler = TripleControlFunction.ErrorHandler


    static let identifier: String = "tripleControlCell"


    @IBOutlet var segment: UISegmentedControl! {
        didSet {
            segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        }
    }


    private var activateFirstAction: Action?
    private var activateSecondAction: Action?
    private var activateThirdAction: Action?


    // MARK: IBActions

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        enableInteraction(false)

        if sender.selectedSegmentIndex == 0 {
            activateFirstAction? { _ in
                self.enableInteraction(true)
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            activateSecondAction? { _ in
                self.enableInteraction(true)
            }
        }
        else {
            activateThirdAction? { _ in
                self.enableInteraction(true)
            }
        }
    }
}

extension TripleControlTableViewCell: ControlFunctionSettable {

    typealias ControlFunctionType = TripleControlFunction


    func setControlFunction(_ function: TripleControlFunction) {
        iconView.image = UIImage(named: "Small" + function.activeIconName)
        nameLabel.text = function.name.uppercased()

        segment.setTitle(function.firstAction.name.uppercased(), forSegmentAt: 0)
        segment.setTitle(function.secondAction.name.uppercased(), forSegmentAt: 1)
        segment.setTitle(function.thirdAction.name.uppercased(), forSegmentAt: 2)

        segment.selectedSegmentIndex = function.activeActionIndex

        activateFirstAction = function.firstAction.action
        activateSecondAction = function.secondAction.action
        activateThirdAction = function.thirdAction.action

        enableInteraction(function.isStatusReceived)
    }
}

private extension TripleControlTableViewCell {

    func enableInteraction(_ enable: Bool) {
        iconView.alpha = enable ? 1.0 : 0.5
        nameLabel.alpha = enable ? 1.0 : 0.5
        segment.isEnabled = enable
    }
}
