//
//  Car+LinkDelegate.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation
import HMKit


extension Car: HMLinkDelegate {

    public func link(_ link: HMLink, authorisationRequestedBy serialNumber: [UInt8], approve: @escaping (() throws -> Void), timeout: TimeInterval) {
        do {
            try approve()
        }
        catch {
            print("\(type(of: self)) -\(#function) failed to approve authorisation: \(error)")

            link.disconnect()

            if HMKit.shared.state == .broadcasting {
                HMKit.shared.stopBroadcasting()
            }
        }
    }

    public func link(_ link: HMLink, commandReceived bytes: [UInt8]) {
        // Only handles VALID AutoAPI responses
        guard let response = AutoAPI.parseBinary(bytes) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.01)) {
            self.parseResponse(response)
        }
    }

    public func link(_ link: HMLink, revokeCompleted bytes: [UInt8]) {
        // Not interested in this app
    }

    public func link(_ link: HMLink, stateChanged newState: HMLinkState, previousState: HMLinkState) {
        switch (newState, previousState) {
        case (.authenticated, .connected):
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.01)) {
                self.connectionState = .authenticated
            }

        default:
            break
        }
    }

    public func link(_ link: HMLink, receivedError error: HMProtocolError) {
        print("Link received an error: \(error)")
    }
}
