//
//  StackStyle.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 19.07.2023.
//

import UIKit

public struct StackStyle: Equatable {

    public let axis: NSLayoutConstraint.Axis
    public let spacing: CGFloat
    public let alignment: UIStackView.Alignment
    public let distribution: UIStackView.Distribution

    public init(axis: NSLayoutConstraint.Axis,
                spacing: CGFloat,
                alignment: UIStackView.Alignment,
                distribution: UIStackView.Distribution) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }

}
