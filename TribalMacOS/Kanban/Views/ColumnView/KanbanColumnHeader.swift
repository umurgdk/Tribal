//
//  KanbanColumnHeader.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanColumnHeader: BaseView, UserInterfaceIdentifiable {
    public var title: String {
        get { titleLabel.stringValue }
        set {
            titleLabel.stringValue = newValue
            titleLabel.sizeToFit()
            needsLayout = true
        }
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        title = ""
    }
    
    // MARK: - Actions
    @objc func showMoreMenu() {
        
    }
    
    // MARK: - View Hierarchy
    private let titleLabel = NSTextField(labelWithString: "").configure {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .secondaryLabelColor
    }
    
    private lazy var moreButton = NSButton().configure {
        var image = NSImage(systemSymbolName: "ellipsis", accessibilityDescription: nil)
        let symbolConfig = NSImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        image = image?.withSymbolConfiguration(symbolConfig)
        image?.isTemplate = true
        
        $0.image = image
        $0.imagePosition = .imageOnly
        $0.contentTintColor = .tertiaryLabelColor
        $0.isBordered = false
    }
    
    let backgroundView = NSVisualEffectView().configure {
        $0.blendingMode = .withinWindow
        $0.material = .windowBackground
    }

    override func setupViewHierarchy() {
        moreButton.sizeToFit()
        
        addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(moreButton)
    }
    
    // MARK: - Layout
    override func layout() {
        super.layout()
        
        backgroundView.frame = bounds
        titleLabel.setFrameOrigin(NSPoint(x: 20, y: bounds.midY - titleLabel.bounds.midY))
        moreButton.setFrameOrigin(NSPoint(x: bounds.maxX - 20 - moreButton.bounds.width, y: bounds.midY - moreButton.bounds.midY))
    }
    
    override var intrinsicContentSize: NSSize {
        NSSize(width: NSView.noIntrinsicMetric, height: 40)
    }
}
