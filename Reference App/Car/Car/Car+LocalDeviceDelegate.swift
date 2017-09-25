//
//  Car+LocalDeviceDelegate.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation
import HMKit


extension Car: LocalDeviceDelegate {

    public func localDevice(didLoseLink link: Link) {
        link.delegate = nil

        // This gives time for HMKit to start it's broadcasting again (that it does automatically after losing a link),
        // so we can actually stop it.
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.01)) {
            self.connectionState = .disconnected

            if LocalDevice.shared.state == .broadcasting {
                LocalDevice.shared.stopBroadcasting()
            }
        }
    }

    public func localDevice(didReceiveLink link: Link) {
        link.delegate = self

        connectionState = .connected

        if LocalDevice.shared.state == .broadcasting {
            LocalDevice.shared.stopBroadcasting()
        }
    }

    public func localDevice(stateChanged state: LocalDeviceState, oldState: LocalDeviceState) {
        switch (state, oldState) {
        case (.bluetoothUnavailable, _):
            connectionState = .unavailable

        case (.broadcasting, _):
            connectionState = .searching

        case (.idle, _):
            connectionState = .idle
        }
    }
}
