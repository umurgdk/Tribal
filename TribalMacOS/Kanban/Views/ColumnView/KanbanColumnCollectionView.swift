//
//  KanbanColumnCollectionView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanColumnCollectionView: NSCollectionView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        isSelectable = true
        allowsEmptySelection = true
        allowsMultipleSelection = true
        backgroundColors = [.windowBackgroundColor, .windowBackgroundColor]
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
