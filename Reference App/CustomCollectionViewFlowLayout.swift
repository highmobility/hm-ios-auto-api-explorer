//
//  CustomCollectionViewFlowLayout.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 02/06/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: UICollectionViewFlowLayout

    override var itemSize: CGSize {
        set {
            super.itemSize = itemSize
        }
        get {
            guard let myself = self as? CustomItemSizeFromBounds else {
                return super.itemSize
            }

            guard let bounds = collectionView?.bounds else {
                return super.itemSize
            }

            return myself.customItemSizeFromBounds(bounds)
        }
    }


    // MARK: UICollectionViewLayout

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let oldSize = collectionView?.bounds.size else {
            return false
        }

        guard oldSize.height != newBounds.height else {
            return false
        }

        return true
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if let flowContext = context as? UICollectionViewFlowLayoutInvalidationContext {
            flowContext.invalidateFlowLayoutDelegateMetrics = true
        }

        super.invalidateLayout(with: context)
    }


    override init() {
        super.init()

        if let myself = self as? CommonInitialiser {
            myself.commonInit()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let myself = self as? CommonInitialiser {
            myself.commonInit()
        }
    }
}
