//
//  Codable+Response.swift
//  
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation
import Vapor

extension Encodable {

    var responseEncoded: Response {
        guard let encodedBody = self.jsonEncoded else {
            return Response(status: .internalServerError)
        }
        return .init(status: .accepted, body: .init(data: encodedBody))
    }

}
