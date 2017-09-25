//
//  Car+Certificates.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation
import HMKit


extension Car {

    // MARK: Public

    public func deleteAccessCertificates<T: Collection>(for carSerial: T) where T.Iterator.Element == UInt8 {
        while LocalDevice.shared.revokeCertificate(withSerial: carSerial) { }
    }

    public func downloadAccessCertificates(accessToken: String, completion: @escaping (Bool) -> Void) {
        do {
            try Telematics.downloadAccessCertificate(accessToken: accessToken) {
                switch $0 {
                case .failure:
                    completion(false)

                case .success:
                    completion(true)
                }
            }
        }
        catch {
            print("Failed to start downloading accessCerts: \(error)")

            completion(false)
        }
    }

    public func isPairedToVehicle<T: Collection>(serial: T) -> Bool where T.Iterator.Element == UInt8 {
        do {
            return try LocalDevice.shared.isAuthorisedToVehicle(serial: serial)
        }
        catch {
            print("\(type(of: self)) -\(#function) Local Device uninitialised!")

            return false
        }
    }

    public func resetAccessCertificatesStorage() {
        LocalDevice.shared.resetStorage()
    }

    public func setDeviceCertificate(_ deviceCertificate: String, devicePrivateKey: String, issuerPublicKey: String) throws {
        self.deviceCert = deviceCertificate
        self.privateKey = devicePrivateKey
        self.publicKey = issuerPublicKey

        try LocalDevice.shared.initialise(deviceCertificate: deviceCertificate, devicePrivateKey: devicePrivateKey, issuerPublicKey: issuerPublicKey)
    }


    // MARK: Internal

    func initialiseLocalDevice() {
        guard let deviceCert = self.deviceCert else {
            fatalError("Missing device certificate!")
        }

        guard let privateKey = self.privateKey else {
            fatalError("Missing device's private key")
        }

        guard let publicKey = self.publicKey else {
            fatalError("Missing issuer public key")
        }

        // If we have all the needed stuff, try to initialise the LocalDevice
        do {
            try LocalDevice.shared.initialise(deviceCertificate: deviceCert, devicePrivateKey: privateKey, issuerPublicKey: publicKey)
        }
        catch {
            // There's no point in initialising with some default values,
            // because the whole app gets its data from the server,
            // the default certificate wouldn't work with anything!

            fatalError("Failed to initialised LocalDevice: \(error)")
        }
    }
}

fileprivate extension Car {

    enum Keys: String {
        case quiteSecretDeviceCert
        case superSecretPublicKey
        case ultraSecretPrivateKey
    }


    // MARK: Vars

    var deviceCert: String? {
        get {
            return KeychainLayer.shared.loadUTF8String(for: Keys.quiteSecretDeviceCert.rawValue)
        }
        set {
            KeychainLayer.shared.saveData(newValue?.utf8EncodedData, label: Keys.quiteSecretDeviceCert.rawValue)
        }
    }

    var publicKey: String? {
        get {
            return KeychainLayer.shared.loadUTF8String(for: Keys.superSecretPublicKey.rawValue)
        }
        set {
            KeychainLayer.shared.saveData(newValue?.utf8EncodedData, label: Keys.superSecretPublicKey.rawValue)
        }
    }

    var privateKey: String? {
        get {
            return KeychainLayer.shared.loadUTF8String(for: Keys.ultraSecretPrivateKey.rawValue)
        }
        set {
            KeychainLayer.shared.saveData(newValue?.utf8EncodedData, label: Keys.ultraSecretPrivateKey.rawValue)
        }
    }
}

fileprivate extension KeychainLayer {

    func loadUTF8String(for key: String) -> String? {
        guard let data = loadData(for: key) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

fileprivate extension String {

    var utf8EncodedData: Data? {
        return data(using: .utf8)
    }
}
