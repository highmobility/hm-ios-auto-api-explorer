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

    @IBOutlet var mainStacksVerticalConstraint: NSLayoutConstraint!

    @IBOutlet var chargingButton: DualControlButton!
    @IBOutlet var doorsLockButton: DualControlButton!
    @IBOutlet var emergencyFlasherButton: DualControlButton!
    @IBOutlet var engineButton: DualControlButton!
    @IBOutlet var frontLightsButton: TripleControlButton!
    @IBOutlet var honkFlashButton: SingleControlButton!
    @IBOutlet var hvacButton: DualControlButton!
    @IBOutlet var interiorLightsButton: DualControlButton!
    @IBOutlet var naviDestinationButton: FullScreenControlButton!
    @IBOutlet var parkingBrakeButton: DualControlButton!
    @IBOutlet var rearLightsButton: DualControlButton!
    @IBOutlet var remoteControlButton: FullScreenControlButton!
    @IBOutlet var rooftopOpacityButton: DualControlButton!
    @IBOutlet var rooftopOpenButton: DualControlButton!
    @IBOutlet var trunkLockButton: DualControlButton!
    @IBOutlet var vehicleLocationButton: FullScreenControlButton!
    @IBOutlet var windowsButton: DualControlButton!
    @IBOutlet var windshieldHeatingButton: DualControlButton!

    @IBOutlet var batteryLabel: UILabel!
    @IBOutlet var mileageLabel: UILabel!
    @IBOutlet var powertrainLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var windscreenDamageLabel: UILabel!


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
        OperationQueue.main.addOperation {
            switch commandType {
            case .other(let command):
                if let charging = command as? ChargingClass {
                    self.batteryLabel.text = "\(charging.battery)%"
                }
                else if let diagnostics = command as? DiagnosticsCommand {
                    self.mileageLabel.text = "\(diagnostics.mileage)km"
                    self.speedLabel.text = "\(diagnostics.speed)km/h"
                }
                else if let windscreen = command as? WindscreenCommand {
                    self.windscreenDamageLabel.text = windscreen.hasDamage ? "X" : "–"
                }

            case .vehicleStatii(let powertrain):
                if Car.shared.charging.isAvailable {
                    self.batteryLabel.text = "\(Car.shared.charging.battery)%"
                }

                if self.statusContainer.alpha == 0.0 {
                    self.statusContainer.alpha = 1.0
                }

                self.powertrainLabel.text = powertrain

            default:
                break
            }
        }
    }
}

private extension ControlOverviewCollectionViewCell {

    func button(for controlFunction: ControlFunction) -> UIButton? {
        switch controlFunction.kind {
        case .charging:             return chargingButton
        case .doorsLock:            return doorsLockButton
        case .doorsStatus:          return nil
        case .emergencyFlasher:     return emergencyFlasherButton
        case .engine:               return engineButton
        case .honkFlash:            return honkFlashButton
        case .hvac:                 return hvacButton
        case .lightsFront:          return frontLightsButton
        case .lightsInterior:       return interiorLightsButton
        case .lightsRear:           return rearLightsButton
        case .naviDestination:      return naviDestinationButton
        case .parkingBrake:         return parkingBrakeButton
        case .remoteControl:        return remoteControlButton
        case .rooftopDimming:       return rooftopOpacityButton
        case .rooftopOpening:       return rooftopOpenButton
        case .trunkAccess:          return trunkLockButton
        case .vehicleLocation:      return vehicleLocationButton
        case .windshieldHeating:    return windshieldHeatingButton
        case .windows:              return windowsButton
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
        else if let button = button as? SingleControlButton, let function = controlFunction as? SingleControlFunction {
            button.setControlFunction(function)
        }
        else if let button = button as? TripleControlButton, let function = controlFunction as? TripleControlFunction {
            button.setControlFunction(function)
        }
    }
}
