//
//  LeftPaginationStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 30.08.2023.
//

import UIKit

final class LeftPaginationStrategy: PaginationStrategy {

    // MARK: - Properties

    weak var scrollView: UIScrollView?
    weak var progressView: UIView?

    // MARK: - Private properties

    private var currentContentWidth: CGFloat?

    // MARK: - PaginationStrategy

    func saveCurrentState() {
        currentContentWidth = scrollView?.contentSize.width
    }

    func resetOffset(canIterate: Bool) {
        guard
            canIterate,
            let currentContentWidth = currentContentWidth,
            let newContentWidth = scrollView?.contentSize.width,
            let progressViewWidth = progressView?.frame.width
        else { return }

        let finalOffset = CGPoint(x: newContentWidth - currentContentWidth - progressViewWidth, y: 0)
        scrollView?.setContentOffset(finalOffset, animated: false)
        self.currentContentWidth = nil
    }

    func addPafinationView() {
        guard let progressView = progressView else {
            return
        }
        scrollView?.addSubview(progressView)
        scrollView?.contentInset.left += progressView.frame.width
    }

    func removePafinationView() {
        progressView?.removeFromSuperview()
        scrollView?.contentInset.left -= progressView?.frame.width ?? .zero
    }

    func getIndexPath<GeneratorType, HeaderGeneratorType, FooterGeneratorType>(
        with sections: [Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>]?
    ) -> IndexPath? {
        IndexPath(row: 0, section: 0)
    }

    func setProgressViewFinalFrame() {
        guard let progressViewFrame = progressView?.frame else {
            return
        }
        // Hack: Update progressView position.
        progressView?.frame = .init(origin: .init(x: -progressViewFrame.width, y: .zero),
                                    size: progressViewFrame.size)
    }

}
