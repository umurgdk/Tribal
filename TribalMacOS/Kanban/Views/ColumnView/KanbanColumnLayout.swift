//
//  NSCollectionViewCompositionalLayout+KanbanColumn.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanColumnLayout: NSCollectionViewLayout {
    var itemAttributes: [IndexPath: NSCollectionViewLayoutAttributes] = [:]
    var estimatedHeight: CGFloat = 270
    
    var columnWidth: CGFloat = 270 {
        didSet { invalidateLayout() }
    }
    
    var gap: CGFloat = 20 {
        didSet { invalidateLayout() }
    }
    
    var insets: CGFloat = 12 {
        didSet { invalidateLayout() }
    }
    
    var contentSize: CGSize = .zero
    override var collectionViewContentSize: NSSize {
        contentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView, let dataSource = collectionView.dataSource else { return }
        guard itemAttributes.isEmpty else { return }
        let numItems = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        
        super.prepare()
        
        var cursor: CGFloat = 0
        let itemLeft = insets
        let itemWidth = columnWidth - insets * 2
        for index in 0..<numItems {
            let indexPath = IndexPath(item: index, section: 0)
            let attrs = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
            attrs.frame = CGRect(x: itemLeft, y: cursor, width: itemWidth, height: estimatedHeight)
            itemAttributes[indexPath] = attrs
            
            cursor += estimatedHeight + gap
        }
        
        cursor += insets - gap
        contentSize = CGSize(width: collectionView.bounds.width, height: cursor)
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return itemAttributes.values.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return itemAttributes[indexPath]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        itemAttributes = [:]
    }
    
    override func invalidateLayout(with context: NSCollectionViewLayoutInvalidationContext) {
        let context = context as! ListInvalidationContext
        if context.invalidateEverything {
            itemAttributes = [:]
            return
        }
        
        var indexPaths: [IndexPath] = Array(context.invalidatedItemIndexPaths ?? [])
        indexPaths.sort()
        
        var cursor: CGFloat = 0
        if let firstItemIndex = indexPaths.first?.item, firstItemIndex > 0, let previousItemAttributes = itemAttributes[IndexPath(item: firstItemIndex - 1, section: 0)] {
            cursor = previousItemAttributes.frame.maxY + gap
        }
        
        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        for indexPath in indexPaths {
            guard let preferredHeight = context.invalidatedPreferredHeights[indexPath] else { continue }
            let attributes = itemAttributes[indexPath] ?? NSCollectionViewLayoutAttributes(forItemWith: indexPath)
            attributes.frame.origin.y = cursor
            attributes.frame.size.height = preferredHeight
            
            itemAttributes[indexPath] = attributes
            
            cursor += attributes.frame.height + gap
            guard indexPath.item + 1 < numberOfItems else { continue }
            for i in (indexPath.item + 1)..<numberOfItems {
                let followingIndexPath = IndexPath(item: i, section: 0)
                if let followingAttributes = itemAttributes[followingIndexPath] {
                    followingAttributes.frame.origin.y = cursor
                    cursor += followingAttributes.size.height + gap
                }
            }
        }
        
        if let lastItemMaxY = itemAttributes.values.lazy.map(\.frame.maxY).max() {
            self.contentSize.height = lastItemMaxY + insets
        }
        
        super.invalidateLayout(with: context)
    }
    
    override class var invalidationContextClass: AnyClass {
        ListInvalidationContext.self
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: NSCollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: NSCollectionViewLayoutAttributes) -> Bool {
        originalAttributes.size.height != preferredAttributes.size.height && preferredAttributes.size.height != 0
    }
    
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: NSCollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes) as! ListInvalidationContext
        if let indexPath = originalAttributes.indexPath {
            context.invalidatePreferredHeight(preferredAttributes.size.height, at: indexPath)
        }
        
        return context
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        false
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: NSCollectionView.DecorationElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return nil
    }
}

class ListInvalidationContext: NSCollectionViewLayoutInvalidationContext {
    private(set) var invalidatedPreferredHeights: [IndexPath: CGFloat] = [:]
    func invalidatePreferredHeight(_ height: CGFloat, at indexPath: IndexPath) {
        invalidateItems(at: [indexPath])
        invalidatedPreferredHeights[indexPath] = height
    }
}
