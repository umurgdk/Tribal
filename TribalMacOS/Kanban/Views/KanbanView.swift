//
//  KanbanView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanView: BaseView {
    // MARK: - View Hierarchy
    public let scrollView = NSScrollView().configure {
        $0.verticalScrollElasticity = .none
        $0.horizontalScrollElasticity = .allowed
        $0.backgroundColor = .windowBackgroundColor
    }
    
    public let boardView = KanbanBoardView()
    public let topDivider = NSBox.divider()
    
    public override func setupViewHierarchy() {
        boardView.frame = bounds
        
        scrollView.documentView = boardView
        scrollView.frame = bounds
        scrollView.autoresizingMask = [.width, .height]
        addSubview(scrollView)

        topDivider.frame = CGRect(x: 0, y: 52, width: bounds.width, height: 1)
        topDivider.autoresizingMask = [.width]
        addSubview(topDivider)
    }
    
    // MARK: - Layout
    public override var isFlipped: Bool { true }
    
    public override func layout() {
        super.layout()
        boardView.frame.size.height = bounds.height - 52
    }
}
