//
//  CarObserver.swift
//  Car
//
//  Created by Mikk Rätsep on 07/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


public protocol CarObserver {

    var carCommandParsed: (CommandType) -> Void { get }

    var carConnectionStateChanged: (ConnectionState) -> Void { get }
}

extension CarObserver {

    // Empty implementation for OPTIONAL usage

    var carCommandParsed: (CommandType) -> Void {
        return { _ in }
    }

    var carConnectionStateChanged: (ConnectionState) -> Void {
        return { _ in }
    }
}


extension Car {

    var carObservers: [CarObserver] {
        return anyHashableObservers.flatMap { $0 as? CarObserver }
    }


    // MARK: Methods - Management

    public func addObserver<O>(_ observer: O) where O: CarObserver & Hashable {
        _ = anyHashableObservers.insert(observer)
    }

    public func removeObserver<O>(_ observer: O) where O: CarObserver & Hashable {
        anyHashableObservers.remove(observer)
    }


    // MARK: Methods - Notifing

    func notifyCommandParsed(_ commandType: CommandType) {
        carObservers.forEach {
            $0.carCommandParsed(commandType)
        }

        displayStuffInThing("cmd: \(commandType), obs. count: \(carObservers.count)")
    }

    func notifyConnectionStateUpdate(_ connectionState: ConnectionState) {
        carObservers.forEach {
            $0.carConnectionStateChanged(connectionState)
        }
    }
}
