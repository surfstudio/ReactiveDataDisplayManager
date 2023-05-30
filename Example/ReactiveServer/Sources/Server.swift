//
//  ReactiveServer.swift
//  
//
//  Created by Никита Коробейников on 30.05.2023.
//

import Vapor
import Foundation

@main
public struct Server {
    public static func main() async throws {
        let socketWire = SocketWire()
        let app = Application()

        app.http.server.configuration.port = 8080

        app.get("greet", use: { _ in
            return "Hello from Reactive Server"
        })
        app.post("send/message", use: { request -> Response in
            guard let data = request.body.data, let rawMessage = try? JSONDecoder().decode(RawMessage.self, from: data) else {
                return .init(status: .badRequest)
            }
            let message = Message(id: UUID().uuidString,
                                  author: rawMessage.author,
                                  body: rawMessage.body,
                                  timestamp: Date().timeIntervalSince1970)
            // TODO: - send message to socket
            return .init(status: .accepted)
        })
        app.webSocket("newMessage", onUpgrade: { request, socket in
            // TODO: - get id from request (deviceId or sessionId)
            socketWire.addSocket(socket, with: UUID().uuidString)
        })
        try app.run()
    }
}
