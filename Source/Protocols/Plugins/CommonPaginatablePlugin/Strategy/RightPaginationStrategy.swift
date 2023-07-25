//
//  RightPaginationStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 25.07.2023.
//

import UIKit

final class RightPaginationStrategy: PaginationStrategy {

    // MARK: - Properties

    weak var scrollView: UIScrollView?
    weak var progressView: UIView?

    // MARK: - PaginationStrategy

    func addPafinationView() {
        guard let progressView = progressView else {
            return
        }
        scrollView?.addSubview(progressView)
        scrollView?.contentInset.right += progressView.frame.width
    }

    func removePafinationView() {
        progressView?.removeFromSuperview()
        scrollView?.contentInset.right -= progressView?.frame.width ?? .zero
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
        guard let progressViewFrame = progressView?.frame, let scrollViewHeight = scrollView?.bounds.height else {
            return
        }
        // Hack: Update progressView position.
        progressView?.frame = .init(origin: .init(x: scrollView?.contentSize.width ?? 0,
                                                  y: (scrollViewHeight / 2) - progressViewFrame.height),
                                    size: progressViewFrame.size)
    }

}
