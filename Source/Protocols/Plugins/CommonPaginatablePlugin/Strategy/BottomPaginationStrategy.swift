//
//  BottomPaginationStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 25.07.2023.
//

import UIKit

final class BottomPaginationStrategy: PaginationStrategy {

    // MARK: - Properties

    weak var scrollView: UIScrollView?
    weak var progressView: UIView?

    // MARK: - PaginationStrategy

    func addPafinationView() {
        guard let progressView = progressView else {
            return
        }
        scrollView?.addSubview(progressView)
        scrollView?.contentInset.bottom += progressView.frame.height
    }

    func removePafinationView() {
        progressView?.removeFromSuperview()
        scrollView?.contentInset.bottom -= progressView?.frame.height ?? .zero
    }

    func getIndexPath<GeneratorType, HeaderGeneratorType, FooterGeneratorType>(
        with sections: [Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>]?
    ) -> IndexPath? {
        guard let sections = sections else {
            return nil
        }
        let lastSectionIndex = sections.count - 1
        let lastCellInLastSectionIndex = sections[lastSectionIndex].generators.count - 1

        return IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
    }

    func setProgressViewFinalFrame() {
        guard let progressViewFrame = progressView?.frame else {
            return
        }
        // Hack: Update progressView position.
        progressView?.frame = .init(origin: .init(x: progressViewFrame.origin.x, y: scrollView?.contentSize.height ?? 0),
                                    size: progressViewFrame.size)
    }

}
