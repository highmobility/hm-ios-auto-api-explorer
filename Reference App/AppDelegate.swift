//
//  AppDelegate.swift
//  Reference App
//
//  Created by Mikk Rätsep on 18/10/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import Car
import HMKit
import UIKit


@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let _ = Car.shared      // Just so that the Car is initialised 

        initialiseLocalDevice() // LocalDevice represents THIS device in HMKit
        initialiseTelematics()  // Telematics connects to the car / emulator through the internet, not Bluetooth (like the LocalDevice does)

        return true
    }
}

private extension AppDelegate {

    func initialiseLocalDevice() {

        LocalDevice.shared.resetStorage()

        /*
         * Before using HMKit, you'll have to initialise the LocalDevice singleton
         * with a snippet from the Platform Workspace:
         *
         *   1. Sign in to the workspace
         *   2. Go to the LEARN section and choose iOS
         *   3. Follow the Getting Started instructions
         *
         * By the end of the tutorial you will have a snippet for initialisation,
         * that looks something like this:
         *
         *   do {
         *       try LocalDevice.shared.initialise(deviceCertificate: Base64String, devicePrivateKey: Base64String, issuerPublicKey: Base64String)
         *   }
         *   catch {
         *       // Handle the error
         *       print("Invalid initialisation parameters, please double-check the snippet: \(error)")
         *   }
         */


        do {
            try LocalDevice.shared.initialise(
                deviceCertificate: "dGVzdBqx6r+ZrF9cR9jXUdeN2d/5y2lNM3fmpKatIEyYIlv4OBj7ntd/6su2N9ppx1JaBM6iZ4kb21NWjZnHy4A5d8B1h+b3RZtEHRH66CG5W8v9KeW8Ys1jkFtPArQSWfGBZCYKBTES3f6xzavljmEki2lO0ckYDzstDaDA7y4PS0dCQ9IRePhAVmxaL1byZCAKZj160WM6",
                devicePrivateKey: "uXrk0ueSBjPc2PxYwt7lSSpilOgDAUVZn8hIjjX9GV4=",
                issuerPublicKey: "9pA3j5EZAfPE0lB4Y7UmS9lKcP0NQPSzICrF+x794Nw8Ss7gKrG6mTHX5MfvH0EzogqdE0LXkfUWwLLtSmqNzA=="
            )
        }
        catch {
            // Handle the error
            print("Invalid initialisation parameters, please double check the snippet.")
        }



        // This just checks if you've seen the above (and are able to follow instructions)
        guard LocalDevice.shared.certificate != nil else {
            fatalError("Please initialise the HMKit with the instrucions above, thanks")
        }
    }

    func initialiseTelematics() {

        let accessToken: String = "97f9bb32-e527-4c8b-9bc2-b157d7d31e9a"


        do {
            try Telematics.downloadAccessCertificate(accessToken: accessToken) {
                switch $0 {
                case .failure(let failureReason):
                    print("Failed to download Access Certificate for Telematics: \(failureReason)")

                case .success(let vehicleSerial):
                    // Set the serial to the Car.framework (the magical helper)
                    Car.shared.activeVehicleSerial = vehicleSerial
                }
            }
        }
        catch {
            print("Failed to download Access Certificate for Telematics: \(error)")
        }
    }
}
