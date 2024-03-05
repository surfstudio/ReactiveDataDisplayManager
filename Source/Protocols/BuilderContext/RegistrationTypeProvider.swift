//
//  RegistrationTypeProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

/// Protocol which is used to provide link `RegistrationType` with dedicated view
public protocol RegistrationTypeProvider {
    /// `nib` or `class` to choose registration type in `UICollectionView` or `UITableView`
    ///  or creation method for nested views
    static var prefferedRegistration: RegistrationType { get }
}
