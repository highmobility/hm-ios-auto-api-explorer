//
//  UIViewController (TouchID).swift
//  Digital Key
//
//  Created by Mikk Rätsep on 19/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import LocalAuthentication
import UIKit


extension UIViewController {

    func authenticateUser(_ completion: @escaping (Bool) -> ()) {
        // Verify that this is called on the main thread!
        guard OperationQueue.current == OperationQueue.main else { return OperationQueue.main.addOperation { self.authenticateUser(completion) } }

        // If all cool – soldier on...
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { success, error in
                if let error = error { print("Failed to authenticate the user: \(error)") }

                OperationQueue.main.addOperation { completion(success) }
            }
        }
        else {
            let alert = UIAlertController(title: "Warning", message: "Your device's TouchID or PIN is not set, do you still want to proceed?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)      { _ in completion(false) })
            alert.addAction(UIAlertAction(title: "Continue", style: .default)   { _ in completion(true) })

            present(alert, animated: true, completion: nil)

            // Prints the 'canEvaluatePolicy' error to the console as well
            print("Can't use TouchID or device's PIN (canEvaluatePolicy error: \(error))")
        }
    }
}

