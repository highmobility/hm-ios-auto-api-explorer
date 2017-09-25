//
//  Command.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


public class Command {

    var becameAvailable: (Command) -> Void


    init(becameAvailable: @escaping (Command) -> Void) {
        self.becameAvailable = becameAvailable
    }
}
