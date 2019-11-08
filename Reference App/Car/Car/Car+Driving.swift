//
//  Car+Driving.swift
//  Car
//
//  Created by Mikk Rätsep on 08/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation
import HMKit


// HAHAHAAA, MASTER HAX
private struct Infoton {

    static var isCommandActive = false
    static var lastSentDate    = Date()
    static var lastSpeedCheck  = Date()
    static var mustStop        = false
    static var newValues       = DrivingValues(angle: 0, speed: 0)
    static var sentValues      = DrivingValues(angle: 0, speed: 0)
    static var speedThreshold  = 0


    struct DrivingValues {
        var angle: Int16
        var speed: Int8
    }
}


extension Car {

    private enum Constants {

        enum Delay: TimeInterval {
            case goal       = 0.5
            case minimum    = 0.1
        }

        enum Speed: Int {
            case driving    = 1
            case threshold  = 3
        }

        enum Timeout: TimeInterval {
            case speed = 0.3
        }
    }


    // MARK: Public Methods

    public func stopDriving() {
        Infoton.mustStop        = true
        Infoton.newValues.speed = 0
        Infoton.speedThreshold  = 0

        updateAlivePing(withSpeed: 0)
        tryToSendDrivingCommand()
    }

    public func updateDriving(with angle: Double, movingForward: Bool) {
        let roundedAngle = Int16(angle.rounded())

        Infoton.newValues = Infoton.DrivingValues(angle: roundedAngle, speed: speed)

        updateSpeedThreshold(movingForward: movingForward)
        updateAlivePing(withSpeed: speed)

        trackSpeedTimeout()
        tryToSendDrivingCommand()
    }
}

private extension Car {

    var speed: Int8 {
        guard abs(Infoton.speedThreshold) > Constants.Speed.threshold.rawValue else { return 0 }

        return Int8(truncatingIfNeeded: (Infoton.speedThreshold.sign * Constants.Speed.driving.rawValue))
    }

    private var shouldSendDrivingCommand: Bool {
        let angleChanged    = Infoton.newValues.angle != Infoton.sentValues.angle
        let isCarMoving     = speed != 0
        let speedChanged    = Infoton.newValues.speed != Infoton.sentValues.speed

        return angleChanged || isCarMoving || speedChanged
    }


    // MARK: Methods

    func trackSpeedTimeout() {
        let dispatchTime = DispatchTime.now() + Constants.Timeout.speed.rawValue + 0.001    // Little extra to be sure the time has passed

        // Last call to this methods updates the time
        Infoton.lastSpeedCheck = Date()

        // Checks after x-seconds if the time-var was updated during the x-seconds and if not - stops the car
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            guard abs(Infoton.lastSpeedCheck.timeIntervalSinceNow) >= Constants.Timeout.speed.rawValue else { return }

            Infoton.newValues.speed = 0
            Infoton.speedThreshold  = 0

            self.updateAlivePing(withSpeed: 0)
        }
    }

    func tryToSendDrivingCommand() {
        let sendingValues   = Infoton.newValues
        var dispatchTime    = DispatchTime.now()

        // Needing to stop overrules others
        if Infoton.mustStop {
            Infoton.mustStop = false
        }
        else {
            guard !Infoton.isCommandActive  else { return }
            guard shouldSendDrivingCommand  else { return }

            let expectedNextDispatchDelay = Constants.Delay.goal.rawValue + Infoton.lastSentDate.timeIntervalSinceNow // The .timeIntervalSinceNow is negative

            dispatchTime = dispatchTime + max(Constants.Delay.minimum.rawValue, expectedNextDispatchDelay)
        }

        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            Infoton.isCommandActive = true

            self.sendRemoteControlDrivingCommand(angle: sendingValues.angle, speed: sendingValues.speed) { dontCareAboutError in
                Infoton.isCommandActive = false
                Infoton.lastSentDate    = Date()
                Infoton.sentValues      = sendingValues

                self.tryToSendDrivingCommand()
            }
        }
    }

    func updateAlivePing(withSpeed speed: Int8) {
        HMLocalDevice.shared.configuration.isAlivePingActive = speed != 0
    }

    func updateSpeedThreshold(movingForward: Bool) {
        // Increases the threshold (+ for forward, - for backward, 0 for other direction [this stops the car])
        if (movingForward != (Infoton.speedThreshold > 0)) && (Infoton.speedThreshold != 0) {
            Infoton.speedThreshold = 0
        }
        else {
            Infoton.speedThreshold += movingForward ? 1 : -1
        }

        // This brilliant check prevents theoretical overflows (after gazillion taps)
        guard abs(Infoton.speedThreshold) > 1_234_567_890 else { return }
        
        Infoton.speedThreshold = Infoton.speedThreshold.sign * (Constants.Speed.threshold.rawValue + 1)
    }
}

private extension Int {
    
    var sign: Int { return (self == 0) ? 0 : abs(self) / self }
}
