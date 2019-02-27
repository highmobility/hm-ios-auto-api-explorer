//
//  Car+Bluetooth.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation
import HMKit


extension Car {

    public var bluetoothName: String? {
        guard device.state == .broadcasting else {
            return nil
        }

        return device.name
    }

    public var isBluetoothEvenPossible: Bool {
        return device.state != .bluetoothUnavailable
    }


    var activeLink: HMLink? {
        if device.links.first?.state == .authenticated {
            return device.links.first
        }

        return nil
    }


    private var device: HMKit {
        return HMKit.shared
    }


    // MARK: Methods

    public func disconnectBluetooth() {
        guard connectionMethod == .bluetooth else {
            return
        }

        device.disconnect()
        device.stopBroadcasting()
    }

    public func startBluetoothBroadcasting(failed: @escaping CommandFailed) {
        guard connectionMethod == .bluetooth else {
            return
        }

        guard device.state == .idle else {
            return
        }

        guard HMKit.shared.certificate != nil else {
            return print("Missing HMKit certificate and other values.")
        }

        do {
            try device.startBroadcasting()
        }
        catch {
            failed(.miscellaneous(error))
        }
    }

    public func stopBluetoothBroadcasting() {
        guard connectionMethod == .bluetooth else {
            return
        }

        device.stopBroadcasting()
    }
}
