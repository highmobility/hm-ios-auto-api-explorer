//
//  RemoteControlViewController.swift
//  Reference App
//
//  Created by Mikk Rätsep on 31/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import UIKit


class RemoteControlViewController: UIViewController {

    @IBOutlet var stopSign: UIButton! {
        didSet {
            // Make sure it's hidden at start
            stopSign.alpha = 0.0
        }
    }

    @IBOutlet var tapContainer: TapContainer!

    private var lastTouchDate = Date()
    private var lastStatus: RemoteControl.ControlModeStatus = .unknown


    // MARK: Methods

    func updateRemoteControlStatus(_ status: RemoteControl.ControlModeStatus) {
        lastStatus = status

        switch status {
        case .available:
            sendStartCommand()

        case .started:
            enableControls(true)

        default:
            bailAndFlail(errorText: nil)
        }
    }


    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        getStatus()
        enableControls(false)
        showStopSign(false)

        tapContainer.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Change the navBar's tint to something else
        navigationController?.navigationBar.barTintColor = UIColor(hexRed: 0x39, green: 0x3D, blue: 0x42, alpha: 1.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Change the navBar tint back to the "correct" one
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.323169, green: 0.337131, blue: 0.362231, alpha: 1.0)  // Amazing right?
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // See if it needs to stop as well
        guard lastStatus == .started else {
            return
        }

        sendStopCommand()
    }
}

extension RemoteControlViewController: TapContainerDelegate {

    func tapContainer(tappedDot index: Int, isForward: Bool) {
        do {
            let carAngle = try TapToCarConverter.calculateCarAngle(withDotIndex: index, isFrontSide: isForward, sideDotCount: tapContainer.oneSideDotsCount)

            Car.shared.updateDriving(with: carAngle, movingForward: isForward)

            showStopSign(true)
            updateStopSignVisibility()
        }
        catch {
            print("\(type(of: self)) -\(#function) failed to calculate Car Angle because: \(error)")
        }
    }

    func tapContainerTappedStop() {
        Car.shared.stopDriving()

        playFeedback()
        showStopSign(false)
    }
}

private extension RemoteControlViewController {

    func bailAndFlail(errorText: String?) {
        OperationQueue.main.addOperation {
            if let text = errorText {
                self.displayStatusBarInfo(text) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func enableControls(_ enable: Bool) {
        tapContainer.isUserInteractionEnabled = enable
        tapContainer.alpha = enable ? 1.0 : 0.5
    }

    func getStatus() {
        Car.shared.getRemoteControlStatus {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) Car.shared.getRemoteControlStatus, error: \(error)")

                self.bailAndFlail(errorText: "Failed to get Remote Control Mode")
            }
        }
    }

    func playFeedback() {
        let generator = UINotificationFeedbackGenerator()

        generator.notificationOccurred(.success)
    }

    func showStopSign(_ show: Bool) {
        let alpha: CGFloat = show ? 1.0 : 0.0

        guard stopSign.alpha != alpha else {
            return
        }

        UIView.animate(withDuration: 0.2) { 
            self.stopSign.alpha = alpha
        }
    }

    func sendStartCommand() {
        Car.shared.sendRemoteControlStartCommand {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) Car.shared.sendRemoteControlStartCommand, error: \(error)")

                self.bailAndFlail(errorText: "Failed to start Remote Control.")
            }
        }
    }

    func sendStopCommand() {
        Car.shared.sendRemoteControlStopCommand { _ in }
    }

    func updateStopSignVisibility() {
        let timeout = 0.5

        // Updates this iVar constantly
        lastTouchDate = Date()

        delay(timeout + 0.001) {
            // Only the last update in a series gets through this
            // Otherwise the time-diff is too small (under the timeout-time...)
            guard fabs(self.lastTouchDate.timeIntervalSinceNow) >= timeout else {
                return
            }

            self.showStopSign(false)
        }
    }
}
