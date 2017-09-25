//
//  FullScreenControlTableViewCell.swift
//  Reference App
//
//  Created by Mikk Rätsep on 23/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class FullScreenControlTableViewCell: ControlTableViewCell {

    static let identifier: String = "fullScreenControlCell"


    private var defaultCoulour: UIColor?


    // MARK: UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        defaultCoulour = backgroundColor
    }


    // MARK: UIView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        defaultCoulour = backgroundColor
    }
}

extension FullScreenControlTableViewCell: ControlFunctionSettable {

    typealias ControlFunctionType = FullScreenControlFunction


    func setControlFunction(_ function: FullScreenControlFunction) {
        iconView.image = UIImage(named: "Small" + function.iconName)
        nameLabel.text = function.name.uppercased()

        enableInteractions(function.isStatusReceived)
    }
}

private extension FullScreenControlTableViewCell {

    func enableInteractions(_ enable: Bool) {
        iconView.alpha = enable ? 1.0 : 0.5
        nameLabel.alpha = enable ? 1.0 : 0.5
    }
}
