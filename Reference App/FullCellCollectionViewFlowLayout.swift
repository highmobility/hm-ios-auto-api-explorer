//
//  FullCellCollectionViewFlowLayout.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 02/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class FullCellCollectionViewFlowLayout: CustomCollectionViewFlowLayout {

}

extension FullCellCollectionViewFlowLayout: CustomFlowLayoutCommonInitialiser {

    var customItemSizeFromBounds: (CGRect) -> CGSize {
        return { $0.size }
    }

    var customScrollDirection: UICollectionView.ScrollDirection { return .horizontal }

    var spacingConstant: CGFloat { return 0.0 }
}
