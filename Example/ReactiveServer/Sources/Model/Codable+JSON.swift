//
//  Codable+JSON.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation

extension Decodable {

    static func from(json data: Data) -> Self? {
        try? JSONDecoder().decode(Self.self, from: data)
    }

}

extension Encodable {

    var jsonEncoded: Data? {
        try? JSONEncoder().encode(self)
    }

}
