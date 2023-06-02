//
//  SocketEvent.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation

enum SocketEvent: Codable {

    case newMessageReceived(Message)

}
