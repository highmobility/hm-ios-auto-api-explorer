//
//  TripleControlButton.swift
//  The App
//
//  Created by Mikk RÃ¤tsep on 21/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class TripleControlButton: ShadowButton {

    private typealias ErrorHandler = TripleControlFunction.ErrorHandler


    private var activateNextAction: ((ErrorHandler?) -> Void)?


    // MARK: Methods

    @objc func didTouchUpInside() {
        enableInteraction(false)

        activateNextAction? { _ in
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

extension TripleControlButton: CommonInitialiser {

    func commonInit() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
}

extension TripleControlButton: ControlFunctionSettable {

    typealias ControlFunctionType = TripleControlFunction


    func setControlFunction(_ function: TripleControlFunction) {
        setImage(UIImage(named: function.activeIconName), for: .normal)

        activateNextAction = function.activateNext

        enableInteraction(function.isStatusReceived)
    }
}

private extension TripleControlButton {

    func enableInteraction(_ enable: Bool) {
        isEnabled = enable
    }
}
