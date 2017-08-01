
//
//  TablePresenter.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation

class TablePresenter: PresenterOutput {

    fileprivate struct Consts {
        public static let maxNameCharacter = 10
    }

    public var model: User!
    public var view: ViewInput!

    func configure() {
        self.view.configure(with: self.model)
    }
}

// MARK: - Event handlers

extension TablePresenter {
    func nameChange(name: String) -> Bool {

        if name.characters.count > Consts.maxNameCharacter {
            return false
        }

        self.model.name = name
        return true
    }

    func surnameChange(surname: String) -> Bool {

        if surname.characters.count > Consts.maxNameCharacter  {
            return false
        }

        self.model.surname = surname
        return true
    }

    func emailChange(email: String) -> Bool{
        self.model.email = email
        return true
    }
}
