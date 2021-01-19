//
//  WindowsStatusViewController.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import UIKit


class WindowsStatusViewController: UIViewController {

    private var windows: [WindowClass]!


    // MARK: IBOutlets

    @IBOutlet var frontLeftPositionLabel: UILabel!
    @IBOutlet var frontRightPositionLabel: UILabel!
    @IBOutlet var rearLeftPositionLabel: UILabel!
    @IBOutlet var rearRightPositionLabel: UILabel!
    @IBOutlet var hatchPositionLabel: UILabel!


    // MARK: IBActions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getWindows()
    }


    // MARK: Methods

    func windowsUpdated(_ windows: [WindowClass]) {
        self.windows = windows

        updateUI()
    }


    // MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if windows == nil {
            getWindows()
        }
        else {
            updateUI()
        }
    }
}

private extension WindowsStatusViewController {

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

    func getWindows() {
        Car.shared.getWindowsState {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) getDoorsState, error: \(error)")

                self.bailAndFlail(errorText: "Failed to get Doors State")
            }
        }
    }

    func updateDoor(with location: Location, positionLabel: UILabel) {
        OperationQueue.main.addOperation {
            if let window = self.windows.first(where: { $0.location == location }) {
                positionLabel.alpha = 1.0
                positionLabel.text = window.isOpen ? "OPEN" : "CLOSED"
                positionLabel.textColor = window.isOpen ? UIColor(named: "Pale") : UIColor(named: "Darkclay")
            }
            else {
                positionLabel.alpha = 0.0
            }
        }
    }

    func updateUI() {
        guard isViewLoaded else {
            return
        }

        updateDoor(with: .frontLeft, positionLabel: frontLeftPositionLabel)
        updateDoor(with: .frontRight, positionLabel: frontRightPositionLabel)
        updateDoor(with: .rearLeft, positionLabel: rearLeftPositionLabel)
        updateDoor(with: .rearRight, positionLabel: rearRightPositionLabel)
        updateDoor(with: .hatch, positionLabel: hatchPositionLabel)
    }
}

