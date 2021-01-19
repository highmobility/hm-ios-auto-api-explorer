//
//  SingleControlButton.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import UIKit


class SingleControlButton: ShadowButton {

    private typealias ErrorHandler = SingleControlFunction.ErrorHandler

    private var activateAction: ((ErrorHandler?) -> Void)?


    // MARK: Methods

    @objc func didTouchUpInside() {
        enableInteraction(false)

        activateAction? { _ in
            self.enableInteraction(true)
        }
    }


    // MARK: UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }
}

extension SingleControlButton: CommonInitialiser {

    func commonInit() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
}

extension SingleControlButton: ControlFunctionSettable {

    typealias ControlFunctionType = SingleControlFunction


    func setControlFunction(_ function: SingleControlFunction) {
        OperationQueue.main.addOperation {
            self.setImage(UIImage(named: function.iconName), for: .normal)
        }

        activateAction = function.activate

        enableInteraction(function.isStatusReceived)
    }
}

private extension SingleControlButton {

    func enableInteraction(_ enable: Bool) {
        OperationQueue.main.addOperation {
            self.isEnabled = enable
        }
    }
}
