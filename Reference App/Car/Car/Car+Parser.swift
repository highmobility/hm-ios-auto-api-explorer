//
//  Car+Parser.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


extension Car {

    var capabilityParsers: [CapabilityParser] {
        return anyHashableParsers.flatMap { $0 as? CapabilityParser }
    }

    var responseParsers: [ResponseParser] {
        return anyHashableParsers.flatMap { $0 as? ResponseParser }
    }

    var vehicleStatusParsers: [VehicleStatusParser] {
        return anyHashableParsers.flatMap { $0 as? VehicleStatusParser }
    }


    // MARK: Methods - Management

    func addParser<P>(_ parser: P) where P: Parser & Hashable {
        _ = anyHashableParsers.insert(parser)
    }


    func addCommandsParsers() {
        addParser(Charging(becameAvailable: { self.charging = $0 as? Charging }))

        addParser(Climate(becameAvailable: { self.climate = $0 as? Climate }))

        addParser(Doors(becameAvailable: { self.doors = $0 as? Doors }))

        addParser(Lights(becameAvailable: { self.lights = $0 as? Lights }))

        addParser(RemoteControl(becameAvailable: { self.remoteControl = $0 as? RemoteControl }))

        addParser(Rooftop(becameAvailable: { self.rooftop = $0 as? Rooftop }))

        addParser(Trunk(becameAvailable: { self.trunk = $0 as? Trunk }))
    }

    func addMetaParsers() {
        addParser(Capabilities(parseCapability: parseCapability))
        displayStuffInThing("added CAPAS")

        addParser(FailureMessage())

        addParser(VehicleStatii(parseVehicleStatus: parseVehicleStatus))
    }


    // MARK: Methods - Parsing

    func parseCapability(_ capability: Capability) {
        var parsers = capabilityParsers

        // THIS IS A TERRIBLE HACK
        if parsers.count == 0 {
            parsers = anyHashableParsers.map { $0 as! CapabilityParser }
        }
        // END OF HACK

        parsers.forEach {
            $0.update(from: capability)
        }
    }

    func parseResponse(_ response: Response) {
        displayStuffInThing("#AHP: \(anyHashableParsers.count)")
        displayStuffInThing("#RP: \(responseParsers.count)")

        var parsers = responseParsers

        // THIS IS A TERRIBLE HACK
        if parsers.count == 0 {
            parsers = anyHashableParsers.map { $0 as! ResponseParser }
        }
        // END OF HACK

        // There can only be ONE matching response
        guard let commandType = parsers.flatMap({ $0.update(from: response) }).first else {
            displayStuffInThing("something failing")

            return
        }

        notifyCommandParsed(commandType)
    }

    func parseVehicleStatus(_ vehicleStatus: VehicleStatus) {
        var parsers = vehicleStatusParsers

        // THIS IS A TERRIBLE HACK
        if parsers.count == 0 {
            parsers = anyHashableParsers.map { $0 as! VehicleStatusParser }
        }
        // END OF HACK

        parsers.forEach {
            $0.update(from: vehicleStatus)
        }
    }
}
