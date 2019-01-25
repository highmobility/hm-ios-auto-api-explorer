# Overview

This sample app for iOS shows the usage of AutoAPI commands and let's you dive straight into testing some of them, specifically:

* Door Locks
* Trunk Access
* Climate
* Rooftop Control
* Remote Control

# Configuration

Before running the app, make sure to configure the following in `AppDelegate.swift`:

1. Initialise HMKit with a valid `Device Certiticate` from the Developer Center https://developers.high-mobility.com/
2. Find an `Access Token` in an emulator from https://developers.high-mobility.com/ and paste it in the source code to download `Access Certificates` from the server

# Run the app

Run the app on your phone or iOS simulator (Bluetooth not available on the simulator).

The app layout consists of simple buttons/segments. E.g. press the Lock Doors button to send the command to the car.

The remote control has a safety feature built into the UX level. In order to trigger movement of the car, the direction has to be tapped continuously - at least twice per second. As soon as tapping is stopped the vehicle goes to standstill. This is to prevent the car to continue moving when the phone is accidentally dropped.

# Questions or Comments ?

If you have questions or if you would like to send us feedback, join our [Slack Channel](https://slack.high-mobility.com/) or email us at [support@high-mobility.com](mailto:support@high-mobility.com).
