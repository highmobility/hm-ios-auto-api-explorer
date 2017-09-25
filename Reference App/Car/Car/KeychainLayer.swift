//
//  KeychainLayer.swift
//  MajesticLink
//
//  Created by Mikk Rätsep on 20/06/2017.
//  Copyright © 2017 High-Mobility. All rights reserved.
//

import CoreFoundation
import Foundation
import Security


struct KeychainLayer {

    static var shared = KeychainLayer()


    // MARK: Vars

    var privateKey: Data? {
        set {
            saveData(newValue, for: .key(isPrivateKey: true))
        }
        get {
            return loadData(for: .key(isPrivateKey: true))
        }
    }

    var publicKey: Data? {
        set {
            saveData(newValue, for: .key(isPrivateKey: false))
        }
        get {
            return loadData(for: .key(isPrivateKey: false))
        }
    }


    // MARK: Methods

    func loadData(for label: String) -> Data? {
        return loadData(for: .data(label: label))
    }

    func saveData(_ data: Data?, label: String) {
        saveData(data, for: .data(label: label))
    }


    private init() { }
}

private extension KeychainLayer {

    enum DataType {
        case data(label: String)
        case key(isPrivateKey: Bool)
    }

    typealias KeychainDictionary = [AnyHashable : Any]


    func deleteEverything() {
        let classes = [kSecClassCertificate, kSecClassGenericPassword, kSecClassIdentity, kSecClassInternetPassword, kSecClassKey]

        classes.forEach {
            let query = [(kSecClass as AnyHashable): $0]

            SecItemDelete(query as NSDictionary)
        }
    }

    func keychainDict(for type: DataType) -> KeychainDictionary {
        var dict: KeychainDictionary = [:]

        switch type {
        case .data(let label):
            dict[kSecClass as AnyHashable] = kSecClassGenericPassword
            dict[kSecAttrAccessible as AnyHashable] = kSecAttrAccessibleAfterFirstUnlock
            dict[kSecAttrAccount as AnyHashable] = label
            dict[kSecAttrService as AnyHashable] = label

        case .key(let isPrivateKey):
            dict[kSecClass as AnyHashable] = kSecClassKey
            dict[kSecAttrAccessible as AnyHashable] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            dict[kSecAttrKeyClass as AnyHashable] = isPrivateKey ? kSecAttrKeyClassPrivate : kSecAttrKeyClassPublic
            dict[kSecAttrLabel as AnyHashable] = "HMKit " + (isPrivateKey ? "Private" : "Public") + " Key"
        }

        return dict
    }

    func loadData(for type: DataType) -> Data? {
        var data: Data?
        var dataRef: AnyObject?
        var dict = keychainDict(for: type)

        dict[kSecReturnData as AnyHashable] = kCFBooleanTrue
        dict[kSecMatchLimit as AnyHashable] = kSecMatchLimitOne

        if SecItemCopyMatching((dict as NSDictionary), &dataRef) == noErr {
            if let resultRef = dataRef {
                data = resultRef as? Data
            }
        }

        return data
    }

    func saveData(_ data: Data?, for type: DataType) {
        var dict = keychainDict(for: type)

        // Delete the old entry
        SecItemDelete(dict as NSDictionary)

        // And save a new one, if the data wasn't nil
        if let data = data {
            dict[kSecValueData as AnyHashable] = data
            
            SecItemAdd((dict as NSDictionary), nil)
        }
    }
}
