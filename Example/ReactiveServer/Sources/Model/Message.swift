//
//  Message.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import Foundation

struct RawMessage: Codable {

    let author: User
    let body: String

}

struct Message: Codable {

    let id: String
    let author: User
    let body: String
    let timestamp: TimeInterval

}
