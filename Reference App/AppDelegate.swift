//
//  AppDelegate.swift
//  Reference App
//
//  Created by Mikk Rätsep on 18/10/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

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
        HMLocalDevice.shared.resetStorage()

        /*
         * Before using HMKit, you'll have to initialise the HMLocalDevice singleton
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
         *       try HMLocalDevice.shared.initialise(deviceCertificate: Base64String, devicePrivateKey: Base64String, issuerPublicKey: Base64String)
         *   }
         *   catch {
         *       // Handle the error
         *       print("Invalid initialisation parameters, please double-check the snippet: \(error)")
         *   }
         */


        HMTelematics.urlBasePath = "https://sandbox.api.staging.high-mobility.net"

        do {
            try HMLocalDevice.shared.initialise(
                certificate: "dGVzdHrzrwEvHAU+P58S/jGy44sbgXxszRzDFPLkvakz6lnsv4dEZY3KeEmvEbWiCg7AI6x9ZtNQSP/uv3sCv9Zp8dUblbFl9A0Pkd+wBsn94yotBWU0GaloNb4M3QR/mWCEqgP9wKxr62+d1+WkZKbOJpyncpRKy8ZDwGZftqviIlQ8TA2MgiwRZy9Wu2GXBf8NC8NahsZU",
                devicePrivateKey: "XS0CSsAqbx2Zd8WQYJ6woq+2948cTtEMMp7PE/o91Iw=",
                issuerPublicKey: "LYU7ctMISWTfCFNahxH/5sxutlVeQi2uQcVkWuxHuRbiLsluKhRk+xzONI9xWEepfX84/Yjg2IPujdn0wlNK0Q=="
            )
        }
        catch {
            // Handle the error
            print("Invalid initialisation parameters, please double-check the snippet: \(error)")
        }


        // This just checks if you've seen the above (and are able to follow instructions)
        guard HMLocalDevice.shared.certificate != nil else {
            fatalError("Please initialise the HMKit with the instrucions above, thanks")
        }
    }

    func initialiseTelematics() {
        let accessToken: String = "0dff6cad-a1b7-4a24-90f7-cfccd14a7fad"

        do {
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken) {
                switch $0 {
                case .failure(let failureReason):
                    print("Failed to download Access Certificate for Telematics: \(failureReason)")

                case .success(let vehicleSerial):
                    // Set the serial to the Car.framework (the magical helper)
                    Car.shared.activeVehicleSerial = vehicleSerial.data
                }
            }
        }
        catch {
            print("Failed to download Access Certificate for Telematics: \(error)")
        }
    }
}
