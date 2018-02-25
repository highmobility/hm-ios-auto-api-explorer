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
    private var isGettingVehicleStatus: Bool = false

    private var collectionViewController: ControlCollectionViewController!
    private var doorsStatusViewController: DoorsStatusViewController?
    private var naviDestinationViewController: NaviDestinationViewController?
    private var remoteControlViewController: RemoteControlViewController?
    private var vehicleLocationViewController: VehicleLocationViewController?
    private var windowsStatusViewController: WindowsStatusViewController?

    private var lastDoorsStatus: [DoorClass]?
    private var lastNaviDestination: NaviDestinationClass!
    private var lastVehicleLocation: VehicleLocationClass?
    private var lastWindowsStatus: [WindowClass]?


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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        doorsStatusViewController = nil
        naviDestinationViewController = nil // TODO: MapView IS RETAINING exessive amounts of memory
        remoteControlViewController = nil
        vehicleLocationViewController = nil // TODO: MapView IS RETAINING exessive amounts of memory
        windowsStatusViewController = nil
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

    func controlFunctionsCreated(_ controlFunctions: [ControlFunction], title: String) {
        guard controlFunctions.count > 0 else {
            return
        }

        collectionViewController.addControlFunctionsSection(controlFunctions)
        titlesView.titles.append(title)
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

        if let controller = viewController as? DoorsStatusViewController {
            doorsStatusViewController = controller

            if let doorsStatus = lastDoorsStatus {
                doorsStatusViewController?.doorsUpdated(doorsStatus)
            }
        }
        else if let controller = viewController as? NaviDestinationViewController {
            naviDestinationViewController = controller

            if let naviDestination = lastNaviDestination {
                naviDestinationViewController?.updateCoordinate(naviDestination.coordinate, name: naviDestination.name)
            }
        }
        else if let controller = viewController as? RemoteControlViewController {
            remoteControlViewController = controller
        }
        else if let controller = viewController as? VehicleLocationViewController {
            vehicleLocationViewController = controller

            if let coordinate = lastVehicleLocation?.coordinate {
                vehicleLocationViewController?.updateCoordinate(coordinate)
            }
        }
        else if let controller = viewController as? WindowsStatusViewController {
            windowsStatusViewController = controller

            if let windowsStatus = lastWindowsStatus {
                windowsStatusViewController?.windowsUpdated(windowsStatus)
            }
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

        // Persist some values
        if let doorsCommand = command as? DoorsCommand {
            lastDoorsStatus = doorsCommand.doors
        }
        else if let doorsCommand = command as? DoorsStatusCommand {
            lastDoorsStatus = doorsCommand.doors
        }
        else if let naviDestination = command as? NaviDestinationClass {
            lastNaviDestination = naviDestination
        }
        else if let vehicleLocation = command as? VehicleLocationClass {
            lastVehicleLocation = vehicleLocation
        }
        else if let windowsCommand = command as? WindowsCommand {
            lastWindowsStatus = windowsCommand.windows
        }
        else if let windowsCommand = command as? WindowsStatusCommand {
            lastWindowsStatus = windowsCommand.windows
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
        guard !isGettingVehicleStatus else {
            return
        }

        isGettingVehicleStatus = true

        enableInteractions(false)
        showInfo("Getting Vehicle Status")

        Car.shared.getVehicleStatii {
            OperationQueue.main.addOperation {
                self.refreshButton.isEnabled = true
            }

            self.isGettingVehicleStatus = false

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

            // This order determines their order in UI
            controlFunctionsCreated(manager.chassisControlFunctions, title: "chassis")
            controlFunctionsCreated(manager.digitalKeyControlFunctions, title: "digital key")
            controlFunctionsCreated(manager.lightsControlFunctions, title: "lights")
            controlFunctionsCreated(manager.otherControlFunctions, title: "others")

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
            switch command {
            case let command as RemoteControlClass:
                remoteControlViewController?.updateRemoteControlStatus(command.controlMode)

            case _ as ChargingClass:
                collectionViewController.receivedOther(commandType)

            case _ as DiagnosticsCommand:
                collectionViewController.receivedOther(commandType)

            case let command as DoorsCommand:
                doorsStatusViewController?.doorsUpdated(command.doors)

            case let command as DoorsStatusCommand:
                doorsStatusViewController?.doorsUpdated(command.doors)

            case let command as NaviDestinationClass:
                naviDestinationViewController?.updateCoordinate(command.coordinate, name: command.name)

            case let command as VehicleLocationClass:
                vehicleLocationViewController?.updateCoordinate(command.coordinate)

            case let command as WindowsCommand:
                windowsStatusViewController?.windowsUpdated(command.windows)

            case let command as WindowsStatusCommand:
                windowsStatusViewController?.windowsUpdated(command.windows)

            default:
                break
            }

            if !updateControlFunctions(with: command) {
                collectionViewController.receivedOther(commandType)
            }

        case .vehicleStatii:
            // Update all the functions
            Car.shared.availableCommands.flatMap { $0 }.forEach {
                self.updateControlFunctions(with: $0)
            }

            // Also update the VS stuff
            collectionViewController.receivedOther(commandType)

            // Some UI things
            clearStatusBarInfo()
            enableInteractions(true)

            OperationQueue.main.addOperation {
                self.refreshButton.isEnabled = true
            }

            isGettingVehicleStatus = false
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
