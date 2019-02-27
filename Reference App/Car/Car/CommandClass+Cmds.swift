//
//  CommandClass+Cmds.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation
import HMKit


public extension Car {

    public typealias CommandFailed = (CommandError?) -> Void


    func sendCommand<C: Collection>(_ command: C, failed: @escaping CommandFailed) where C.Iterator.Element == UInt8 {
        switch connectionMethod {
        case .bluetooth:
            sendBluetoothCommand(command, failed: failed)

        case .telematics:
            sendTelematicsCommand(command, failed: failed)
        }
    }
}

private extension Car {

    func sendBluetoothCommand<C: Collection>(_ command: C, failed: @escaping CommandFailed) where C.Iterator.Element == UInt8 {
        guard let link = activeLink else {
            return failed(.missing(.authenticatedLink))
        }

        do {
            try link.send(command: command) {
                switch $0 {
                case .error(let error):
                    failed(.miscellaneous(error))

                case .success:
                    // Bluetooth returns GOOD response through LinkDelegate
                    break
                }
            }
        }
        catch {
            failed(.miscellaneous(error))
        }
    }

    func sendTelematicsCommand<C: Collection>(_ command: C, failed: @escaping CommandFailed) where C.Iterator.Element == UInt8 {
        guard let vehicleSerial = activeVehicleSerial else {
            return failed(.missing(.vehicleSerial))
        }

        do {
            try HMTelematics.sendCommand(command, serial: vehicleSerial) {
                switch $0 {
                case .failure(let failure):
                    failed(.telematicsFailure(failure))

                case .success(let data):
                    guard let command = data else {
                        return
                    }

                    // Only handles VALID AutoAPI responses
                    guard let response = AutoAPI.parseBinary(command) else {
                        return
                    }

                    self.parseResponse(response)
                }
            }
        }
        catch {
            failed(.miscellaneous(error))
        }
    }
}
