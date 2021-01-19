//
//  DoorsStatusViewController.swift
//  The App
//
//  Created by Mikk Rätsep on 20/02/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import UIKit


class DoorsStatusViewController: UIViewController {

    private var doors: [DoorClass]!


    // MARK: IBOutlets

    @IBOutlet var frontLeftStackView: UIStackView!
    @IBOutlet var frontLeftLockLabel: UILabel!
    @IBOutlet var frontLeftPositionLabel: UILabel!

    @IBOutlet var frontRightStackView: UIStackView!
    @IBOutlet var frontRightLockLabel: UILabel!
    @IBOutlet var frontRightPositionLabel: UILabel!

    @IBOutlet var rearLeftStackView: UIStackView!
    @IBOutlet var rearLeftLockLabel: UILabel!
    @IBOutlet var rearLeftPositionLabel: UILabel!

    @IBOutlet var rearRightStackView: UIStackView!
    @IBOutlet var rearRightLockLabel: UILabel!
    @IBOutlet var rearRightPositionLabel: UILabel!

    @IBOutlet var hatchStackView: UIStackView!
    @IBOutlet var hatchLockLabel: UILabel!
    @IBOutlet var hatchPositionLabel: UILabel!


    // MARK: IBActions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getDoors()
    }


    // MARK: Methods

    func doorsUpdated(_ doors: [DoorClass]) {
        self.doors = doors

        updateUI()
    }


    // MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if doors == nil {
            getDoors()
        }
        else {
            updateUI()
        }
    }
}

private extension DoorsStatusViewController {

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

    func getDoors() {
        Car.shared.getDoorsState {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) getDoorsState, error: \(error)")

                self.bailAndFlail(errorText: "Failed to get Doors State")
            }
        }
    }

    func updateDoor(with location: Location, stack: UIStackView, lockLabel: UILabel, positionLabel: UILabel) {
        OperationQueue.main.addOperation {
            if let door = self.doors.first(where: { $0.location == location }) {
                stack.alpha = 1.0

                lockLabel.text = door.isLocked ? "LOCKED" : "UNLOCKED"
                positionLabel.text = door.isOpen ? "OPEN" : "CLOSED"

                lockLabel.textColor = !door.isLocked ? UIColor(named: "Pale") : UIColor(named: "Darkclay")
                positionLabel.textColor = door.isOpen ? UIColor(named: "Pale") : UIColor(named: "Darkclay")
            }
            else {
                stack.alpha = 0.0
            }
        }
    }

    func updateUI() {
        guard isViewLoaded else {
            return
        }

        updateDoor(with: .frontLeft, stack: frontLeftStackView, lockLabel: frontLeftLockLabel, positionLabel: frontLeftPositionLabel)
        updateDoor(with: .frontRight, stack: frontRightStackView, lockLabel: frontRightLockLabel, positionLabel: frontRightPositionLabel)
        updateDoor(with: .rearLeft, stack: rearLeftStackView, lockLabel: rearLeftLockLabel, positionLabel: rearLeftPositionLabel)
        updateDoor(with: .rearRight, stack: rearRightStackView, lockLabel: rearRightLockLabel, positionLabel: rearRightPositionLabel)
        updateDoor(with: .hatch, stack: hatchStackView, lockLabel: hatchLockLabel, positionLabel: hatchPositionLabel)
    }
}
