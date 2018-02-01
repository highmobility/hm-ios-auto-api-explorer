//
//  ControlViewController.swift
//  Reference App
//
//  Created by Mikk Rätsep on 19/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import UIKit


class ControlViewController: UIViewController {

    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var titlesView: TitlesScrollView!
    @IBOutlet var containerView: UIView!


    private var isDismissingViewController: Bool = false

    private var collectionViewController: ControlCollectionViewController!
    private var remoteControlViewController: RemoteControlViewController?


    // MARK: IBActions

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        sender.isEnabled = false

        getVehicleStatus()
    }


    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        Car.shared.addObserver(self)

        refreshButton.isEnabled = false

        configureTopViews()
        startConnection()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ControlCollectionViewController {
            controller.didScrollWithIndexProgress = titlesView.setIndexProgress
            titlesView.didScrollWithIndexProgress = controller.setIndexProgress

            controller.presentViewController = { identifier in
                OperationQueue.main.addOperation {
                    self.presentViewController(identifier: identifier)
                }
            }

            collectionViewController = controller
        }
    }
}

extension ControlViewController: CarObserver {

    var carCommandParsed: (CommandType) -> Void {
        return receivedCommandParsed
    }

    var carConnectionStateChanged: (ConnectionState) -> Void {
        return receivedConnectionStateChange
    }
}

private extension ControlViewController {

    func configureTopViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "AUTO API"

        titlesView.titles = ["overview"]
    }

    func dismissViewController() {
        OperationQueue.main.addOperation {
            self.performSegue(withIdentifier: "unwindToConnect", sender: nil)
        }
    }

    func enableInteractions(_ enable: Bool) {
        OperationQueue.main.addOperation {
            self.titlesView.isUserInteractionEnabled = enable
            self.collectionViewController.collectionView?.isUserInteractionEnabled = enable
        }
    }

    func externalControlFunctionsCreated(_ controlFunctions: [ControlFunction]) {
        guard controlFunctions.count > 0 else {
            return
        }

        titlesView.titles.append("commands")
        collectionViewController.addControlFunctionsSection(controlFunctions)
    }

    func presentViewController(identifier: String) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else {
            return
        }

        if let controller = viewController as? RemoteControlViewController {
            remoteControlViewController = controller
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    func startConnection() {
        switch Car.shared.connectionMethod {
        case .bluetooth:
            Car.shared.startBluetoothBroadcasting(failed: receivedCommandError)

        case .telematics:
            // There's no connect-auth-etc. part with telematics
            getCapabilities()
        }
    }

    func showInfo(_ text: String) {
        OperationQueue.main.addOperation {
            self.displayStatusBarInfo(text, isPermanent: true, completion: nil)
        }
    }

    @discardableResult func updateControlFunctions(with command: CommandClass) -> Bool {
        guard let updatedFunctions = ControlFunctionsManager.shared.updateControlFunctions(from: command), updatedFunctions.count > 0 else {
            return false
        }

        updatedFunctions.forEach {
            self.collectionViewController.receivedControlFunctionUpdate($0)
        }

        return true
    }


    // MARK: Methods - Get from the car

    func getCapabilities() {
        enableInteractions(false)
        showInfo("Getting Capabilities")

        Car.shared.getCapabilities(failed: receivedCommandError)
    }

    func getVehicleStatus() {
        enableInteractions(false)
        showInfo("Getting Vehicle Status")

        Car.shared.getVehicleStatii {
            self.refreshButton.isEnabled = true

            self.clearStatusBarInfo()
            self.enableInteractions(true)
            self.receivedCommandError($0)
        }
    }


    // MARK: Methods - Received from the car

    func receivedCommandParsed(_ commandType: CommandType) {
        switch commandType {
        case .capabilities:
            let allPossibleCommands = Car.shared.availableCommands
            let manager = ControlFunctionsManager.shared

            manager.receivedCapabilities(for: allPossibleCommands)

            externalControlFunctionsCreated(manager.externalControlFunctions)

            delay(0.1) {
                self.getVehicleStatus()
            }

        case .failureMessage(let failureMessage):
            var dismiss: Bool = true
            let text: String

            switch failureMessage.reason {
            case .executionTimeout:
                dismiss = false
                text = "Execution timed out"

            case .incorrectState:
                text = "In an incorrect state"

            case .invalidAutoApiCommand:
                dismiss = false
                text = "Invalid an AutoAPI command"

            case .unauthorised:
                text = "Unauthorised"

            case .unsupportedCapability:
                text = "Unsupported capability"

            case .vehicleAsleep:
                text = "Vehicle is sleeping"
            }

            displayStatusBarInfo(text) {
                guard dismiss else {
                    return
                }

                self.navigationController?.popViewController(animated: true)
            }

        case .other(let command):
            // Try to update remote if possible
            if let command = command as? RemoteControlClass {
                remoteControlViewController?.updateRemoteControlStatus(command.controlMode)
            }

            if !updateControlFunctions(with: command) {
                collectionViewController.receivedOther(commandType)
            }

        case .vehicleStatii:
            // Update all the functions
            Car.shared.availableCommands.flatMap { $0 }.forEach {
                self.updateControlFunctions(with: $0)
            }

            // Some additional statii needed...
            if Car.shared.lights.isAvailable {
                delay(0.5) {
                    Car.shared.getLightsState(failed: self.receivedCommandError)
                }
            }

            // Also update the VS stuff
            collectionViewController.receivedOther(commandType)

            // Some UI things
            clearStatusBarInfo()
            enableInteractions(true)
        }
    }

    func receivedCommandError(_ error: CommandError?) {
        guard let error = error else {
            return
        }

        var errorText = "\(error)"

        if case .miscellaneous(let miscError) = error {
            errorText = "\(miscError)"
        }
        else if case .missing(let missing) = error {
            errorText = "Missing: \(missing)"
        }
        else if case .telematicsFailure(let reason) = error {
            errorText = reason
        }

        isDismissingViewController = true

        // Display what ever we have
        displayStatusBarInfo(errorText) {
            self.dismissViewController()
        }
    }

    func receivedConnectionStateChange(_ connectionState: ConnectionState) {
        switch connectionState {
        case .authenticated:
            showInfo("Authenticated")

            delay(0.1) {
                self.getCapabilities()
            }

        case .disconnected:
            guard !isDismissingViewController else {
                return
            }

            displayStatusBarInfo("Disconnected", for: 1.5) {
                self.dismissViewController()
            }

        case .searching:
            if let name = Car.shared.bluetoothName {
                showInfo(name)
            }
            else {
                showInfo("\(connectionState)".capitalized)
            }

        case .idle:
            break

        default:
            showInfo("\(connectionState)".capitalized)
        }
    }
}
