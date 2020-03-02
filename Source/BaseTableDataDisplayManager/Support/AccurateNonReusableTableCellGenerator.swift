//
//  AccurateNonReusableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

/// Class for generating non-reusable Configurable UITableViewCell with calculated height
public class AccurateNonReusableTableCellGenerator<Cell: Configurable & AccurateHeight>: BaseNonReusableTableCellGenerator<Cell> where Cell: UITableViewCell {

    public var cellHeight: CGFloat {
        return Cell.getHeight(forWidth: cell?.frame.width ?? 0, with: model)
    }

    public var estimatedCellHeight: CGFloat? {
        return Cell.getHeight(forWidth: cell?.frame.width ?? 0, with: model)
    }

}
