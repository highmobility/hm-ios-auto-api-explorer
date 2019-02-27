//
//  FailureMessage.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class FailureMessageClass: CommandClass {

    public enum Reason: UInt8 {
        // Blatant copy from AutoAPI
        case unsupportedCapability  = 0x00
        case unauthorised           = 0x01
        case incorrectState         = 0x02
        case executionTimeout       = 0x03
        case vehicleAsleep          = 0x04
        case invalidAutoApiCommand  = 0x05
    }


    public private(set) var identifier: UInt16 = 0x0000
    public private(set) var reason: Reason = .unsupportedCapability
    public private(set) var type: UInt8 = 0x00


    override init() {
        super.init()
        
        isAvailable = true
        isMetaCommand = true
    }
}

extension FailureMessageClass: ParserResponseOnly {

    @discardableResult func update(from response: AACapability) -> CommandType? {
        guard let failureMessage = response as? AAFailureMessage,
            let failureReason = failureMessage.reason?.value,
            let reason = Reason(rawValue: failureReason.rawValue),
            let failedMessageIdentifier = failureMessage.messageIdentifier?.value,
            let failedMessageType = failureMessage.messageType?.value else {
                return nil
        }

        self.identifier = failedMessageIdentifier
        self.reason = reason
        self.type = failedMessageType

        return .failureMessage(self)
    }
}
