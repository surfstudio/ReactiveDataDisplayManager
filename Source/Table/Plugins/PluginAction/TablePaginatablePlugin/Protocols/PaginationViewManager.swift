//
//  PaginationViewManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 25.07.2023.
//

import UIKit

protocol PaginationStrategy: ContentOffsetStateKeeper {

    func getIndexPath(with manager: BaseCollectionManager?) -> IndexPath?
    func addPafinationView()
    func removePafinationView()
    func setProgressViewFinalFrame()
}
