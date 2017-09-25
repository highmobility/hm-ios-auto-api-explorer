//
//  DualControlTableViewCell.swift
//  Reference App
//
//  Created by Mikk Rätsep on 23/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class DualControlTableViewCell: ControlTableViewCell {

    private typealias ErrorHandler = DualControlFunction.ErrorHandler


    static let identifier: String = "dualControlCell"


    @IBOutlet var segment: UISegmentedControl! {
        didSet {
            segment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        }
    }


    private var activateMainAction: ((ErrorHandler?) -> Void)?
    private var activateOppositeAction: ((ErrorHandler?) -> Void)?


    // MARK: IBActions

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        enableInteraction(false)

        if sender.selectedSegmentIndex == 0 {
            activateMainAction? { _ in
                self.enableInteraction(true)
            }
        }
        else {
            activateOppositeAction? { _ in
                self.enableInteraction(true)
            }
        }
    }
}

extension DualControlTableViewCell: ControlFunctionSettable {

    typealias ControlFunctionType = DualControlFunction


    func setControlFunction(_ function: DualControlFunction) {
        iconView.image = UIImage(named: "Small" + function.activeIconName)
        nameLabel.text = function.name.uppercased()

        segment.setTitle(function.mainAction.name.uppercased(), forSegmentAt: 0)
        segment.setTitle(function.oppositeAction.name.uppercased(), forSegmentAt: 1)

        segment.selectedSegmentIndex = function.isMainActionActive ? 0 : 1

        activateMainAction = function.mainAction.activate
        activateOppositeAction = function.oppositeAction.activate

        enableInteraction(function.isStatusReceived)
    }
}

private extension DualControlTableViewCell {

    func enableInteraction(_ enable: Bool) {
        iconView.alpha = enable ? 1.0 : 0.5
        nameLabel.alpha = enable ? 1.0 : 0.5
        segment.isEnabled = enable
    }
}
