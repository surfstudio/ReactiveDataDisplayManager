//
//  URLSessionApiClient.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation
import Combine

final class URLSessionApiClient: ApiClient {

    private let server: String

    init(server: String) {
        self.server = server
    }

    // MARK: - ApiClient

    func get<Response>(_ method: String,
                       responseType: Response.Type) -> AnyPublisher<Response, Error> where Response : Decodable {
        var request = URLRequest(url: URL(string: [server, method].joined(separator: "/"))!)
        request.httpMethod = "GET"
        return execute(request: request)
    }

    func post<Request, Response>(_ method: String,
                                 requestBody: Request,
                                 responseType: Response.Type) -> AnyPublisher<Response, Error> where Request : Encodable, Response : Decodable {
        var request = URLRequest(url: URL(string: [server, method].joined(separator: "/"))!)
        request.httpMethod = "POST"
        request.httpBody = requestBody.jsonEncoded
        return execute(request: request)
    }

}

// MARK: - Private

private extension URLSessionApiClient {

    func execute<Response>(request: URLRequest) -> AnyPublisher<Response, any Error> where Response : Decodable {
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
