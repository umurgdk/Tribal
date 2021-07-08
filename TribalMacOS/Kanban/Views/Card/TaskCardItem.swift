//
//  TaskCardItem.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

public class TaskCardItem: NSCollectionViewItem, UserInterfaceIdentifiable {
    public override var isSelected: Bool {
        didSet { cardView.isSelected = isSelected }
    }
    
    public func setTask(_ task: Task, coverImage: NSImage?) {
        cardView.configure(with: task, coverImage: coverImage)
    }

    // MARK: - View Hierarchy
    lazy var cardView = TaskCardView()
    public override func loadView() {
        view = cardView
    }
    
    // MARK: - Layout
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let height = cardView.heightForWidth(layoutAttributes.size.width)
        
        if layoutAttributes.size.height != height {
            attributes.size.height = height
        }
        
        return attributes
    }
}

