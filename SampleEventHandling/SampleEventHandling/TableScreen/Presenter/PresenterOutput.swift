//
//  PresenterOutput.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation

protocol PresenterOutput {

    func configure()

    func nameChange(name: String) -> Bool
    func surnameChange(surname: String) -> Bool
    func emailChange(email: String) -> Bool
}
