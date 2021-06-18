//
//  SectionedDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.06.2021.
//

import UIKit

/// Manager for sections
public protocol SectionedDataDisplayManager: AnyObject {

    // MARK: - Associatedtypes

    associatedtype SectionType

    // MARK: - Data source methods

    /// Adds a new section with header and footer
    ///
    /// - Parameter section: New section with headers and footers generators.
    func addSection(_ section: SectionType)


    /// Removes section including cell generators.
    ///
    /// - Parameter section: Existing section with headers and footers generators.
    func removeSection(_ section: SectionType)

    /// Removes all sections including generators.
    func clearAllSections()
}
