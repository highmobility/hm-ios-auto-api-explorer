//
//  ParserResponseOnly.swift
//  Car
//
//  Created by Mikk Rätsep on 10/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


protocol ParserResponseOnly: Parser {

}

extension ParserResponseOnly {

    /*
     Empty implementation for some meta-commands
     */


    // MARK: CapabilityParser

    func update(from capability: Capability) {

    }
}
