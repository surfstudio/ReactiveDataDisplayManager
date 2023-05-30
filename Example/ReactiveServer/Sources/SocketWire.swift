//
//  File.swift
//  
//
//  Created by Никита Коробейников on 30.05.2023.
//

import Foundation
import Vapor

final class SocketWire {

    var openSockets: [String: WebSocket] = [:]

    func addSocket(_ socket: WebSocket, with id: String) {
        socket.onClose.whenComplete { [weak self] _ in
            self?.openSockets.removeValue(forKey: id)
        }
        openSockets.updateValue(socket, forKey: id)
    }

}
