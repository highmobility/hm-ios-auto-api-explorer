//
//  Collection+Unique.swift
//  Reference App
//
//  Created by Mikk Rätsep on 17/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element: Hashable {

    func unique(sortedBy areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool = { _,_  in true }) -> [Iterator.Element] {
        return Array(Set(self)).sorted(by: areInIncreasingOrder)
    }
}

extension Sequence {

    func withAddition(_ addition: Iterator.Element...) -> [Iterator.Element] {
        return self + addition
    }

    func unique(areEqual: (Iterator.Element, Iterator.Element) -> Bool, sortedBy areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool = { _,_  in true }) -> [Iterator.Element] {
        let initial: [Iterator.Element] = []

        return reduce(initial) { (result, element) -> [Iterator.Element] in
            guard !result.contains(where: { areEqual($0, element) }) else {
                return result
            }

            return result.withAddition(element)
        }
    }
}
