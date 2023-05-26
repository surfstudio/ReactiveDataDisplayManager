//
//  StateKeeper.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import Foundation

protocol StateKeeper {

    func addDelegate<T: AnyObject>(delegate: T, with key: String)
    func removeDelegate(by key: String)

}
