//
//  ControlFunctionsCollectionViewCell.swift
//  Reference App
//
//  Created by Mikk Rätsep on 22/05/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import UIKit


class ControlFunctionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tableView: UITableView!


    var controlFunctions: [ControlFunction] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var presentViewController: ((String) -> Void)?


    // MARK: Methods

    func updateControlFunction(_ function: ControlFunction) {
        guard let index = controlFunctions.firstIndex(where: { $0.kind == function.kind }) else {
            return print("\(type(of: self)) -\(#function) doesn't contain function: \(function.name)")
        }

        controlFunctions[index] = function

        OperationQueue.main.addOperation {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}

extension ControlFunctionsCollectionViewCell: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controlFunctions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controlFunction = controlFunctions[indexPath.row]
        let cell: UITableViewCell

        switch controlFunction {
        case is DualControlFunction:
            cell = tableView.dequeueReusableCell(withIdentifier: DualControlTableViewCell.identifier, for: indexPath)

        case is FullScreenControlFunction:
            cell = tableView.dequeueReusableCell(withIdentifier: FullScreenControlTableViewCell.identifier, for: indexPath)

        case is SingleControlFunction:
            cell = tableView.dequeueReusableCell(withIdentifier: SingleControlTableViewCell.identifier, for: indexPath)

        case is TripleControlFunction:
            cell = tableView.dequeueReusableCell(withIdentifier: TripleControlTableViewCell.identifier, for: indexPath)

        default:
            fatalError("Complete failure. Just give up. Go home.")
        }

        // Cast it for ease of yüüse
        if let cell = cell as? DualControlTableViewCell, let function = controlFunction as? DualControlFunction {
            cell.setControlFunction(function)
        }
        else if let cell = cell as? FullScreenControlTableViewCell, let function = controlFunction as? FullScreenControlFunction {
            cell.setControlFunction(function)
        }
        else if let cell = cell as? SingleControlTableViewCell, let function = controlFunction as? SingleControlFunction {
            cell.setControlFunction(function)
        }
        else if let cell = cell as? TripleControlTableViewCell, let function = controlFunction as? TripleControlFunction {
            cell.setControlFunction(function)
        }
        else {
            print("\(type(of: self)) -\(#function) failed to handle: \(controlFunction.name) of type: \(controlFunction.kind) in a cell: \(cell)")
        }

        return cell
    }
}

extension ControlFunctionsCollectionViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let function = controlFunctions[indexPath.row] as? FullScreenControlFunction else {
            return
        }

        presentViewController?(function.viewControllerID)
    }
}
