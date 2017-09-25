//
//  ControlCollectionViewController.swift
//  Reference App
//
//  Created by Mikk Rätsep on 19/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Car
import UIKit


class ControlCollectionViewController: UICollectionViewController {

    var presentViewController: ((String) -> Void)?
    var didScrollWithIndexProgress: ((CGFloat) -> Void)?

    private var controlFunctionsSections: [[ControlFunction]] = []
    private var overviewCell: ControlOverviewCollectionViewCell?


    // MARK: Methods

    func addControlFunctionsSection(_ section: [ControlFunction]) {
        controlFunctionsSections.append(section)

        OperationQueue.main.addOperation {
            self.collectionView?.reloadData()
        }
    }

    func receivedControlFunctionUpdate(_ controlFunction: ControlFunction) {
        updateControlFunction(controlFunction)
    }

    func receivedOther(_ commandType: CommandType) {
        overviewCell?.updateOther(commandType)
    }

    func setIndexProgress(_ progress: CGFloat) {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.contentOffset.x = collectionView.bounds.width * progress
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + controlFunctionsSections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (indexPath.row == 0) ? "controlOverviewCellID" : "controlFunctionsCellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        // Configure a specific cell
        if let cell = cell as? ControlOverviewCollectionViewCell {
            if let functions = controlFunctionsSections.first {
                cell.controlFunctions = functions
            }

            cell.presentViewController = presentViewController

            overviewCell = cell
        }
        else if let cell = cell as? ControlFunctionsCollectionViewCell {
            cell.controlFunctions = controlFunctionsSections[indexPath.row - 1]
            cell.presentViewController = presentViewController
        }

        return cell
    }


    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging || scrollView.isDecelerating else {
            return
        }

        didScrollWithIndexProgress?(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}

private extension ControlCollectionViewController {

    func updateControlFunction(_ function: ControlFunction) {
        let sameAsFunction: (ControlFunction) -> Bool = { $0.kind == function.kind }
        let sameAsFunction2: (Int, ControlFunction) -> Bool = { sameAsFunction($1) }
        let containsMatchingFunction: (Int, [ControlFunction]) -> Bool = { $1.contains(where: sameAsFunction) }

        guard let horisontalIdx = controlFunctionsSections.enumerated().first(where: containsMatchingFunction)?.offset else {
            return print("\(type(of: self)) -\(#function) failed to resolve horisontal index for: \(function.name)")
        }

        guard let verticalIdx = controlFunctionsSections[horisontalIdx].enumerated().first(where: sameAsFunction2)?.offset else {
            return print("\(type(of: self)) -\(#function) failed to resolve vertical index for: \(function.name)")
        }

        let indexPath = IndexPath(item: (horisontalIdx + 1), section: 0)

        controlFunctionsSections[horisontalIdx][verticalIdx] = function

        // Can't update a cell that's not visible
        if let cell = self.collectionView?.cellForItem(at: indexPath) as? ControlFunctionsCollectionViewCell {
            cell.updateControlFunction(function)
        }
        else {
            OperationQueue.main.addOperation {
                self.collectionView?.reloadItems(at: [indexPath])
            }
        }

        // Try to update the overView as well
        overviewCell?.updateControlFunction(function)
    }
}
