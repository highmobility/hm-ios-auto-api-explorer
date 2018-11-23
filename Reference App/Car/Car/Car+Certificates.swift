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
        while HMLocalDevice.shared.revokeSingleCertificate(withSerial: carSerial, isProviding: true) { }
        while HMLocalDevice.shared.revokeSingleCertificate(withSerial: carSerial, isProviding: false) { }
    }

    public func downloadAccessCertificates(accessToken: String, completion: @escaping (Bool) -> Void) {
        do {
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken) {
                switch $0 {
                case .failure(let reason):
                    print("Failed:", reason)
                    completion(false)

                case .success:
                    print("Registered access certificates:", HMLocalDevice.shared.registeredCertificates)
                    print("Stored     access certificates:", HMLocalDevice.shared.storedCertificates)

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
            return try HMLocalDevice.shared.isAuthorisedToVehicle(serial: serial)
        }
        catch {
            print("\(type(of: self)) -\(#function) Local Device uninitialised!")

            return false
        }
    }

    public func resetAccessCertificatesStorage() {
        HMLocalDevice.shared.resetStorage()
    }
}

private extension Car {

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

private extension KeychainLayer {

    func loadUTF8String(for key: String) -> String? {
        guard let data = loadData(for: key) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

private extension String {

    var utf8EncodedData: Data? {
        return data(using: .utf8)
    }
}
