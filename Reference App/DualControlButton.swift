//
//  DualControlButton.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 08/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class DualControlButton: ShadowButton {

    private typealias ErrorHandler = DualControlFunction.ErrorHandler


    private var activateOtherAction: ((ErrorHandler?) -> Void)?


    // MARK: Methods

    @objc func didTouchUpInside() {
        enableInteraction(false)

        activateOtherAction? { _ in
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

extension DualControlButton: CommonInitialiser {

    func commonInit() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
}

extension DualControlButton: ControlFunctionSettable {

    typealias ControlFunctionType = DualControlFunction


    func setControlFunction(_ function: DualControlFunction) {
        OperationQueue.main.addOperation {
            self.setImage(UIImage(named: function.activeIconName), for: .normal)
        }

        activateOtherAction = function.activateOther

        enableInteraction(function.isStatusReceived)
    }
}

private extension DualControlButton {

    func enableInteraction(_ enable: Bool) {
        OperationQueue.main.addOperation {
            self.isEnabled = enable
        }
    }
}
