//
//  Collection+RegisterableItem.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

public protocol CollectionCellRegisterableItem: RegisterableItem {

    /// Register cell in collectionView
    ///
    /// - Parameter collectionView: CollectionView, in which cell will be registered
    func registerCell(in collectionView: UICollectionView)
}

public protocol CollectionHeaderRegisterableItem: RegisterableItem {

    /// Register cell in collectionView
    ///
    /// - Parameter collectionView: CollectionView, in which header will be registered
    func registerHeader(in collectionView: UICollectionView)
}

public protocol CollectionFooterRegisterableItem: RegisterableItem {

    /// Register cell in collectionView
    ///
    /// - Parameter collectionView: CollectionView, in which footer will be registered
    func registerFooter(in collectionView: UICollectionView)
}
