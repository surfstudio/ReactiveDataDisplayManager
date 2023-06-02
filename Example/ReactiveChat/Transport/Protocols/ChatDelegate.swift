//
//  ChatDelegate.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import Foundation

protocol ChatDelegate: AnyObject {

    func onUpdated(messages: [Message])

}
