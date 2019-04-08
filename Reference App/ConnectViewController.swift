//
//  ConnectViewController.swift
//  The App
//
//  Created by Mikk Rätsep on 19/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import UIKit


class ConnectViewController: UIViewController {

    @IBOutlet var connectionSegment: UISegmentedControl! {
        didSet {
            connectionSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
            connectionSegment.setEnabled(Car.shared.isBluetoothEvenPossible, forSegmentAt: 1)

            connectionSegment.selectedSegmentIndex = 0
        }
    }


    // MARK: IBActions

    @IBAction func connectionSegmentValueChanged(_ sender: UISegmentedControl) {
        changeConnectionMethod(with: sender)
    }

    @IBAction func unwindToConnect(_ sender: UIStoryboardSegue) {
        // Handle the connection stuff
        switch Car.shared.connectionMethod {
        case .bluetooth:
            Car.shared.disconnectBluetooth()
            Car.shared.stopBluetoothBroadcasting()

        case .telematics:
            // Don't have to disconnect with telematics (not a sessioned connection)
            break
        }

        // Remove the unwinding car observer
        if let observer = sender.source as? ControlViewController {
            Car.shared.removeObserver(observer)
        }
    }


    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        changeConnectionMethod(with: connectionSegment)
    }
}

private extension ConnectViewController {

    func changeConnectionMethod(with segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            Car.shared.connectionMethod = .telematics
        }
        else {
            Car.shared.connectionMethod = .bluetooth
        }
    }
}
