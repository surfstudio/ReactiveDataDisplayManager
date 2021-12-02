//
//  File.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum СhoiceTableSection {
    case newSection(TableSection? = nil)
    case byIndex(Int)
    case lastSection
}

public struct TableSection {
    let header: TableHeaderGenerator?
    let footer: TableFooterGenerator?
}
