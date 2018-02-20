//
//  SingleControlTableViewCell.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import UIKit


class SingleControlTableViewCell: ControlTableViewCell {

    private typealias ErrorHandler = SingleControlFunction.ErrorHandler


    static let identifier: String = "singleControlCell"

    private var activateAction: ((ErrorHandler?) -> Void)?


    @IBOutlet var button: RoundedButton!


    // MARK: IBActions

    @IBAction func buttonTapped(_ sender: UIButton) {
        enableInteraction(false)

        activateAction? { _ in
            self.enableInteraction(true)
        }
    }
}

extension SingleControlTableViewCell: ControlFunctionSettable {

    typealias ControlFunctionType = SingleControlFunction


    func setControlFunction(_ function: SingleControlFunction) {
        iconView.image = UIImage(named: "Small" + function.iconName) ?? UIImage(named: function.iconName)
        nameLabel.text = function.name.uppercased()

        button.setTitle(function.action.name.uppercased(), for: .normal)

        activateAction = function.activate

        enableInteraction(function.isStatusReceived)
    }
}

private extension SingleControlTableViewCell {

    func enableInteraction(_ enable: Bool) {
        iconView.alpha = enable ? 1.0 : 0.5
        nameLabel.alpha = enable ? 1.0 : 0.5
        button.alpha = enable ? 1.0 : 0.5
        button.isEnabled = enable
    }
}
