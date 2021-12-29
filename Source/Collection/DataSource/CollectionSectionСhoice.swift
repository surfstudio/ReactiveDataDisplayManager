//
//  CollectionSectionСhoice.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import Foundation

public enum CollectionSectionСhoice {

    /// Case for adding generators to a new section. The default header and footer are nil
    case newSection(header: CollectionHeaderGenerator? = nil, footer: CollectionFooterGenerator? = nil)

    /// Case for adding generators to a section at a specified index
    case byIndex(Int)

    /// Case for adding generators to the last section.
    case lastSection
}
