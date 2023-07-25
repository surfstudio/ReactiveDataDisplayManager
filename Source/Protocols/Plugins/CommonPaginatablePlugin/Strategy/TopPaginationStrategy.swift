//
//  TopPaginationStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 25.07.2023.
//

import UIKit

final class TopPaginationStrategy: PaginationStrategy {

    // MARK: - Properties

    weak var scrollView: UIScrollView?
    weak var progressView: UIView?

    // MARK: - Private properties

    private var currentContentHeight: CGFloat?

    // MARK: - PaginationStrategy

    func saveCurrentState() {
        currentContentHeight = scrollView?.contentSize.height
    }

    func resetOffset(canIterate: Bool) {
        guard
            canIterate,
            let currentContentHeight = currentContentHeight,
            let newContentHeight = scrollView?.contentSize.height,
            let progressViewHeight = progressView?.frame.height
        else { return }

        let finalOffset = CGPoint(x: 0, y: newContentHeight - currentContentHeight - progressViewHeight)
        scrollView?.setContentOffset(finalOffset, animated: false)
        self.currentContentHeight = nil
    }

    func addPafinationView() {
        guard let progressView = progressView else {
            return
        }
        scrollView?.addSubview(progressView)
        scrollView?.contentInset.top += progressView.frame.height
    }

    func removePafinationView() {
        progressView?.removeFromSuperview()
        scrollView?.contentInset.top -= progressView?.frame.height ?? .zero
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
        progressView?.frame = .init(origin: .init(x: progressViewFrame.origin.x, y: -progressViewFrame.height),
                                    size: progressViewFrame.size)
    }

}
