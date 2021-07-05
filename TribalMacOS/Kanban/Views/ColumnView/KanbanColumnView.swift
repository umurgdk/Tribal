//
//  KanbanColumnView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

fileprivate class FlippedClipView: NSClipView {
    override var isFlipped: Bool { true }
}

class KanbanColumnView: BaseView {
    public var dataSource: KanbanColumnDataSource? {
        get { collectionView.dataSource as? KanbanColumnDataSource }
        set {
            collectionView.dataSource = newValue
            dataSource?.collectionView = collectionView
        }
    }
    
    public var title: String {
        get { headerView.title }
        set { headerView.title = newValue}
    }
    
    public var columnWidth: CGFloat = 270 {
        didSet {
            columnLayout.columnWidth = columnWidth
        }
    }
    
    // MARK: - Lifecycle
    override func viewWillStartLiveResize() {
        super.viewWillStartLiveResize()
        scrollView.contentView.postsBoundsChangedNotifications = false
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        scrollView.contentView.postsBoundsChangedNotifications = true
        scrollOffsetDidChange()
    }
    
    // MARK: - View Hierarchy
    private let headerView = KanbanColumnHeader()
    private let rightBorder = NSBox.divider()
    
    private let columnLayout = KanbanColumnLayout()
    private let collectionView = NSCollectionView().configure {
        $0.backgroundColors = [.windowBackgroundColor, .windowBackgroundColor]
    }
    
    private let scrollDivider = NSBox.divider()
    private let scrollView = OrientedScrollView().configure {
        $0.contentView.postsBoundsChangedNotifications = true
        $0.automaticallyAdjustsContentInsets = true
        $0.hasVerticalScroller = false
        $0.verticalScroller = nil
        $0.contentView = FlippedClipView()
        $0.backgroundColor = .windowBackgroundColor
    }
    
    override func setupViewHierarchy() {
        collectionView.collectionViewLayout = columnLayout
        collectionView.register(TaskCard.self)
        collectionView.dataSource = dataSource
        
        scrollView.documentView = collectionView
        scrollView.additionalSafeAreaInsets.top = 40
        scrollView.frame = bounds
        scrollView.autoresizingMask = [.width, .height]
        scrollDivider.isHidden = true
        
        addSubview(scrollView)
        addSubview(headerView)
        addSubview(rightBorder)
        addSubview(scrollDivider)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollOffsetDidChange), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)
    }
    
    // MARK: - Layout
    override var isFlipped: Bool { true }
    override func layout() {
        super.layout()
        
        let origin = bounds.origin
        headerView.frame = CGRect(origin: origin, size: CGSize(width: bounds.width, height: 39))
        scrollDivider.frame = CGRect(origin: CGPoint(x: origin.x, y: headerView.frame.maxY), size: CGSize(width: bounds.width, height: 1))
        rightBorder.frame = CGRect(origin: CGPoint(x: bounds.width - 1, y: origin.y), size: CGSize(width: 1, height: bounds.height))
    }
    
    // MARK: - Scroll Events
    @objc func scrollOffsetDidChange() {
        let dividerShouldBeHidden = scrollView.contentView.bounds.minY <= -40
        if scrollDivider.isHidden != dividerShouldBeHidden {
            scrollDivider.animator().isHidden = dividerShouldBeHidden
            headerView.backgroundView.material = dividerShouldBeHidden ? .windowBackground : .headerView
        }
    }
}
