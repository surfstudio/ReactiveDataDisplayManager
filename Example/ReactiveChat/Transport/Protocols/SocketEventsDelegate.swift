//
//  SocketEventsDelegate.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation

protocol SocketEventsDelegate: AnyObject {

    func onReceive(message: Message)

}
