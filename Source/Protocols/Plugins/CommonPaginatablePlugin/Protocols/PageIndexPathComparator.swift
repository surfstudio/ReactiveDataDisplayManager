//
//  PageIndexPathComparator.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 20.07.2023.
//

import Foundation

protocol PageIndexPathComparator {

    // Реализация хранит weak референс на SectionsProvider для доступа к массиву генераторов.
    var sectionProvider: (any SectionsProvider)? { get set }

    // Сравнивает текущий индекс из willDisplay с последним/первым индексом.
    func compare(currentIndexPath: IndexPath) -> Bool

}
