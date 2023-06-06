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

        app.get("greet", use: { _ -> Response in
            return Feedback(description: "Hello").responseEncoded
        })
        app.post("send", use: { request in
            guard let data = request.body.data, let rawMessage = try? JSONDecoder().decode(RawMessage.self, from: data) else {
                return Feedback(description: "can't decode your raw message").responseEncoded
            }
            let message = Message(id: UUID().uuidString,
                                  author: rawMessage.author,
                                  body: rawMessage.body,
                                  timestamp: Date().timeIntervalSince1970)
            let event = SocketEvent.newMessageReceived(message)
            if let encodedMessage = try? JSONEncoder().encode(event) {
                socketWire.broadcast(data: encodedMessage)
            }

            return Feedback(description: "got your message").responseEncoded
        })
        app.webSocket("connect", onUpgrade: { request, socket in
            // TODO: - get id from request (deviceId or sessionId)
            socketWire.addSocket(socket, with: UUID().uuidString)
        })
        try app.run()
    }
}
