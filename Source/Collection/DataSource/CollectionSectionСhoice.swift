//
//  CollectionSectionСhoice.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum CollectionSectionСhoice {
    case newSection(header: CollectionHeaderGenerator? = nil, footer: CollectionFooterGenerator? = nil)
    case byIndex(Int)
    case lastSection
}
