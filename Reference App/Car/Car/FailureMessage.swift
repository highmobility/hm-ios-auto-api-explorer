//
//  FailureMessage.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class FailureMessage {

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
}

extension FailureMessage: ParserResponseOnly {

}

extension FailureMessage: Hashable {

    public var hashValue: Int {
        var hashValue = "\(Swift.type(of: self))".hashValue

        hashValue += identifier.hashValue
        hashValue += reason.hashValue
        hashValue += type.hashValue

        return hashValue
    }


    public static func ==(lhs: FailureMessage, rhs: FailureMessage) -> Bool {
        return (lhs.identifier == rhs.identifier) && (lhs.reason == rhs.reason) && (lhs.type == rhs.type)
    }
}

extension FailureMessage: ResponseParser {

    @discardableResult func update(from response: Response) -> CommandType? {
        guard let response = response.value as? AutoAPI.FailureMessageCommand.Response else {
            return nil
        }

        // Extract the values
        guard let reason = Reason(rawValue: response.failureReason.rawValue) else {
            return nil
        }

        self.identifier = (UInt16(response.failedMessageIdentifier.msb) << 8) + UInt16(response.failedMessageIdentifier.lsb)
        self.reason = reason
        self.type = response.failedMessageType

        return .failureMessage(self)
    }
}
