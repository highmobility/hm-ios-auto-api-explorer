//
//  CustomFlowLayoutCommonInitialiser.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 02/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


protocol CustomFlowLayoutCommonInitialiser: CustomItemSizeFromBounds, CommonInitialiser {

    var customScrollDirection: UICollectionView.ScrollDirection { get }
    var spacingConstant: CGFloat { get }
}

extension CustomFlowLayoutCommonInitialiser where Self: UICollectionViewFlowLayout {

    func commonInit() {
        minimumLineSpacing = spacingConstant
        minimumInteritemSpacing = spacingConstant

        scrollDirection = customScrollDirection
        sectionInset = UIEdgeInsets(inset: spacingConstant)
    }
}
