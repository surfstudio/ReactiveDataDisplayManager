// 
//  TitleTableViewCellModel.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 27.07.2021.
//

struct TitleTableViewCellModel {
    let title: String
    let canBeFocused: Bool

    init(title: String, canBeFocused: Bool = true) {
        self.title = title
        self.canBeFocused = canBeFocused
    }
}
