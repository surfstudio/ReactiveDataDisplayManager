//
//  СhoiceCollectionSection.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum СhoiceCollectionSection {
    case newSection(LegoSection? = nil)
    case byIndex(Int)
    case lastSection
}

public struct LegoSection {
    let header: CollectionHeaderGenerator?
    let footer: CollectionFooterGenerator?
}
