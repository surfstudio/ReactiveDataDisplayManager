//
//  TableSectionСhoice.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum TableSectionСhoice {
    case newSection(header: TableHeaderGenerator? = nil, footer: TableFooterGenerator? = nil)
    case byIndex(Int)
    case lastSection
}
