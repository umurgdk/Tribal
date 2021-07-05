//
//  KanbanView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

class KanbanView: BaseView {
    // MARK: - View Hierarchy
    let scrollView = NSScrollView().configure {
        $0.verticalScrollElasticity = .none
        $0.horizontalScrollElasticity = .allowed
        $0.backgroundColor = .windowBackgroundColor
    }
    
    let boardView = KanbanBoardView()
    let topDivider = NSBox.divider()
    
    override func setupViewHierarchy() {
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
    override var isFlipped: Bool { true }
    
    override func layout() {
        super.layout()
        boardView.frame.size.height = safeAreaRect.height
    }
}
