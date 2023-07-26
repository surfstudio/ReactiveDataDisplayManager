//
//  RegistrationTypeProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

public protocol RegistrationTypeProvider {
    static var prefferedRegistration: RegistrationType { get }
}
