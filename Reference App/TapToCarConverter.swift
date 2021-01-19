//
//  TapToCarConverter.swift
//  Remote Control
//
//  Created by Mikk Rätsep on 12/09/2016.
//  Copyright © 2016 High-Mobility GmbH. All rights reserved.
//

import Foundation


class TapToCarConverter {

    // MARK: Constants

    private struct Constants {
        static let maxTurningAngle      = 100.0

        static let leftTurnIsPositive   = true
        static let leftTurnMaxAngle     = Constants.maxTurningAngle * (Constants.leftTurnIsPositive ? 1.0 : -1.0)
    }


    // MARK: Public Stuff...

    /// This can be set for easier use of *calculateCarAngle()*
    static var oneSideDotsCount = 0

    /// The errors from this class.
    enum TapToCarConverterError: Error {

        /// The supplied *dot count* is too little (must be at least 2).
        case invalidDotCount
    }


    // MARK: Public Class Methods

    /// Calculates the *angle* to be sent to the car.
    ///
    /// - parameter withDotIndex: The index of the dot in it's side (beginning from the left), 0-based.
    /// - parameter isFrontSide:  If the dot is facing the front or back.
    /// - parameter sideDotCount: The number of dots on 1 side, defaults to *oneSideDotsCount*.
    ///
    /// - throws: Throws the *invalidDotCount* if there are less than 2 dots for a side.
    ///
    /// - returns: The angle to send to the car.
    class func calculateCarAngle(withDotIndex index: Int, isFrontSide: Bool, sideDotCount: Int = oneSideDotsCount) throws -> Double {
        guard sideDotCount > 1 else { throw TapToCarConverterError.invalidDotCount }

        // The step is found by totaling 1 side's degrees and multipling it with the number of gaps (one less than the number of dots).
        let dotStepDegrees  = (Constants.maxTurningAngle * 2.0) / Double(sideDotCount - 1)
        let sideSign        = isFrontSide ? 1.0 : -1.0

        // The angle is found by starting from the left and steping (with the index) to the right
        return (Constants.leftTurnMaxAngle - (Double(index) * dotStepDegrees)) * sideSign
    }
}

