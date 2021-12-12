//
//  СhoiceCollectionSection.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum СhoiceCollectionSection {
    case newSection(header: CollectionHeaderGenerator? = nil, footer: CollectionFooterGenerator? = nil)
    case byIndex(Int)
    case lastSection
}

//public struct CollectionSection {
//    public var generators: [CollectionCellGenerator]
//    public var header: CollectionHeaderGenerator
//    public var footer: CollectionFooterGenerator
//}
