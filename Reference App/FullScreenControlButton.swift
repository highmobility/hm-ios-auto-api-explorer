//
//  FullScreenControlButton.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 08/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class FullScreenControlButton: ShadowButton {

    var presentViewController: ((String) -> Void)?

    private var viewControllerID: String?


    // MARK: Methods

    @objc func didTouchUpInside() {
        guard let identifier = viewControllerID else {
            return
        }

        presentViewController?(identifier)
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

extension FullScreenControlButton: CommonInitialiser {

    func commonInit() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
}

extension FullScreenControlButton: ControlFunctionSettable {

    typealias ControlFunctionType = FullScreenControlFunction


    func setControlFunction(_ function: FullScreenControlFunction) {
        OperationQueue.main.addOperation {
            self.setImage(UIImage(named: function.iconName), for: .normal)
        }

        viewControllerID = function.viewControllerID

        enableInteraction(function.isStatusReceived)
    }
}

private extension FullScreenControlButton {

    func enableInteraction(_ enable: Bool) {
        OperationQueue.main.addOperation {
            self.isEnabled = enable
        }
    }
}
