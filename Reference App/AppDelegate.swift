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

fileprivate extension AppDelegate {

    func initialiseLocalDevice() {

        /*

         Before using the HMKit, you must initialise the LocalDevice with a snippet from the Developer Center:
         - go to Developer Center
         - LOGIN
         - choose DEVELOP (in top-left, the (2nd) button with a spanner)
         - choose APPLICATIONS (in the left)
         - look for SANDBOX app
         - click on the "Device Certificates" on the app
         - choose the SANDBOX DEVICE
         - copy the whole snippet
         - paste it below this comment box
         - you made it!

         Bonus steps after completing the above:
         - relax
         - celebrate
         - explore the APIs


         An example of a snippet similar to the one copied from the Developer Center (do not use, will obviously not work):

         do {
            try Car.shared.setDeviceCertificate(Base64String,
                                                devicePrivateKey: Base64String,
                                                issuerPublicKey: Base64String)
         }
         catch {
            // Handle the error
            print("Invalid initialisation parameters, please double-check the snippet: \(error)")
         }

         */


        // PASTE THE SNIPPET HERE


        // This just checks if you've seen the above (and are able to follow instructions)
        guard LocalDevice.shared.certificate != nil else {
            fatalError("Please initialise the HMKit with the instrucions above, thanks")
        }
    }

    func initialiseTelematics() {

        /*

         Before using Telematics in HMKit, you must get the Access Certificate for the car / emualator:
         - go to Developer Center
         - LOGIN
         - go to Tutorials ›› SDK ›› iOS for instructions to connect a service to the car
         - authorise the service
         - take a good look into the mirror, you badass
         - open the SANDBOX car emulator
         - on the left, in the Authorised Services list, choose the Service you used before
         - copy the ACCESS TOKEN
         - paste it below to the appropriately named variable

         Bonus steps again:
         - get a beverage
         - quench your thirst
         - change the world with your mind
         - explore the APIs


         An example of an access token:

         6fb79a87-19bf-4db6-8ad5-12c3341603c1

         */


        let accessToken: String = "PASTE THE ACCESS TOKEN HERE"


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
