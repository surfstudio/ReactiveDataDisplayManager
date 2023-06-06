//
//  ApiClient.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Combine

protocol ApiClient {

    func get<Response: Decodable>(_ method: String,
                                  responseType: Response.Type) -> AnyPublisher<Response, any Error>

    func post<Request: Encodable, Response: Decodable>(_ method: String,
                                                       requestBody: Request,
                                                       responseType: Response.Type) -> AnyPublisher<Response, any Error>

}
