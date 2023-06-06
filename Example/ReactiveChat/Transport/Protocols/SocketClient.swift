//
//  SocketClient.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation

protocol SocketClient {

    func setDelegate(_ delegate: SocketEventsDelegate)

    func connect()

    func disconnect()

}
