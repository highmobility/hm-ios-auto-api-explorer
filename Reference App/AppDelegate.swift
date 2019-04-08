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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let _ = Car.shared      // Just so that the Car is initialised 

        initialiseHMKit()
        initialiseTelematics()  // Telematics connects to the car / emulator through the internet, not Bluetooth (like the HMKit does)

        return true
    }
}

private extension AppDelegate {

    func initialiseHMKit() {
        HMKit.shared.resetStorage()

        /*
         * Before using HMKit, you'll have to initialise the HMKit singleton
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
         *       try HMKit.shared.initialise(deviceCertificate: Base64String, devicePrivateKey: Base64String, issuerPublicKey: Base64String)
         *   }
         *   catch {
         *       // Handle the error
         *       print("Invalid initialisation parameters, please double-check the snippet: \(error)")
         *   }
         */


        <#Paste the HMKit INITIALISATION SNIPPET here#>


        // This just checks if you've seen the above (and are able to follow instructions)
        guard HMKit.shared.certificate != nil else {
            fatalError("Please initialise the HMKit with the instrucions above, thanks")
        }
    }

    func initialiseTelematics() {
        let accessToken: String = "<#ACCESS TOKEN#>"

        do {
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken) {
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
