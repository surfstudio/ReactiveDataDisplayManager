//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Никита Коробейников on 09.06.2021.
//

import UIKit

final class TitleCollectionReusableView: UICollectionReusableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(title: String) {
        self.titleLabel.text = title
    }

}
