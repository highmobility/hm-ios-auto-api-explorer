//
//  ControlOverviewCollectionViewCell.swift
//  Reference App
//
//  Created by Mikk Rätsep on 22/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import UIKit


class ControlOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet var buttons: [UIButton]! {
        didSet {
            // Hide the buttons until the capability for each is received
            buttons.forEach { self.hideButton($0) }
        }
    }

    @IBOutlet var statusContainer: UIView! {
        didSet {
            // Hide it at start
            statusContainer.alpha = 0.0
        }
    }

    @IBOutlet var chargingButton: DualControlButton!
    @IBOutlet var doorsLockButton: DualControlButton!
    @IBOutlet var frontLightsButton: TripleControlButton!
    @IBOutlet var interiorLightsButton: DualControlButton!
    @IBOutlet var rearLightsButton: DualControlButton!
    @IBOutlet var remoteControlButton: FullScreenControlButton!
    @IBOutlet var rooftopOpacityButton: DualControlButton!
    @IBOutlet var rooftopOpenButton: DualControlButton!
    @IBOutlet var trunkLockButton: DualControlButton!
    @IBOutlet var windshieldHeatingButton: DualControlButton!

    @IBOutlet var batteryLabel: UILabel!
    @IBOutlet var damageLabel: UILabel!


    // MARK: Vars

    var controlFunctions: [ControlFunction] = [] {
        didSet {
            controlFunctionsReceived(controlFunctions)
        }
    }

    var presentViewController: ((String) -> Void)?


    // MARK: Methods

    func updateControlFunction(_ function: ControlFunction) {
        guard let button = button(for: function) else {
            return
        }

        updateButton(button, with: function)
    }

    func updateOther(_ commandType: CommandType) {
        switch commandType {
        case .other(let command) where command is Charging:
            fallthrough

        case .vehicleStatii:
            OperationQueue.main.addOperation {
                if let charging = Car.shared.charging {
                    self.batteryLabel.text = "\(charging.battery)%"
                }

                if self.statusContainer.alpha == 0.0 {
                    self.statusContainer.alpha = 1.0
                }
            }

        default:
            break
        }
    }
}

private extension ControlOverviewCollectionViewCell {

    func button(for controlFunction: ControlFunction) -> UIButton? {
        switch controlFunction.kind {
        case .charging:             return chargingButton
        case .doorsLock:            return doorsLockButton
        case .lightsFront:          return frontLightsButton
        case .lightsInterior:       return interiorLightsButton
        case .lightsRear:           return rearLightsButton
        case .trunkAccess:          return trunkLockButton
        case .rooftopDimming:       return rooftopOpacityButton
        case .rooftopOpening:       return rooftopOpenButton
        case .windshieldHeating:    return windshieldHeatingButton
        case .remoteControl:        return remoteControlButton
        }
    }

    func controlFunctionsReceived(_ functions: [ControlFunction]) {
        functions.forEach {
            // Find and handle a button for a capabiliy
            if let button = self.button(for: $0) {
                self.showButton(button)
                self.updateButton(button, with: $0)
            }
        }
    }

    func hideButton(_ button: UIButton) {
        button.alpha = 0.0
    }

    func showButton(_ button: UIButton) {
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: 0.25) {
                button.alpha = 1.0
            }
        }
    }

    func updateButton(_ button: UIButton, with controlFunction: ControlFunction) {
        // Cast and set
        if let button = button as? DualControlButton, let function = controlFunction as? DualControlFunction {
            button.setControlFunction(function)
        }
        else if let button = button as? FullScreenControlButton, let function = controlFunction as? FullScreenControlFunction {
            button.presentViewController = presentViewController
            button.setControlFunction(function)
        }
        else if let button = button as? TripleControlButton, let function = controlFunction as? TripleControlFunction {
            button.setControlFunction(function)
        }
    }
}
