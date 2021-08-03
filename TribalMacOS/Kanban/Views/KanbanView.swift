//
//  KanbanView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanView: BaseView {
    public let scrollView = NSScrollView().configure {
        $0.verticalScrollElasticity = .none
        $0.horizontalScrollElasticity = .allowed
        $0.backgroundColor = .windowBackgroundColor
        $0.wantsLayer = true
    }
    
    
    public func setContentView(_ contentView: NSView) {
        contentView.frame = bounds
        scrollView.documentView = contentView
        needsLayout = true
    }
    
    public override func setupViewHierarchy() {
        wantsLayer = true
        
        scrollView.frame = bounds
        scrollView.autoresizingMask = [.width, .height]
        addSubview(scrollView)

        let topDivider = NSBox.divider()
        topDivider.frame = CGRect(x: 0, y: 52, width: bounds.width, height: 1)
        topDivider.autoresizingMask = [.width]
        addSubview(topDivider)
    }
    
    // MARK: - Layout
    public override var isFlipped: Bool { true }
    
    public override func layout() {
        super.layout()
        scrollView.documentView?.frame.size.height = bounds.height - 52
    }
}
