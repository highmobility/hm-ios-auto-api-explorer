//
//  String+Email.swift
//  Demo App
//
//  Created by Mikk Rätsep on 28/11/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension String {

    var isEmail: Bool {
        let regexString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let predicate   = NSPredicate(format: "SELF MATCHES %@", regexString)

        return predicate.evaluate(with: self)
    }
}

