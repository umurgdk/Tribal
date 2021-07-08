//
//  KanbanColumnCollectionViewDelegate.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class KanbanColumnCollectionViewDelegate: NSObject, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
}
