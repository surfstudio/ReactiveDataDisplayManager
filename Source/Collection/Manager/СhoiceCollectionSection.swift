//
//  СhoiceCollectionSection.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum СhoiceCollectionSection {
    case newSection(CollectionSection? = nil)
    case byIndex(Int)
    case lastSection
}

public struct CollectionSection {
    let header: CollectionHeaderGenerator?
    let footer: CollectionFooterGenerator?
}
