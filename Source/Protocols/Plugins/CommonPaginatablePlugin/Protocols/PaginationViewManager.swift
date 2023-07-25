//
//  PaginationViewManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 25.07.2023.
//

import UIKit

protocol PaginationStrategy: ContentOffsetStateKeeper {

    func getIndexPath<GeneratorType, HeaderGeneratorType, FooterGeneratorType>(
        with sections: [Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>]?
    ) -> IndexPath?
    func addPafinationView()
    func removePafinationView()
    func setProgressViewFinalFrame()
}
