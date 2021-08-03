//
//  KanbanBoardView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit
import SnapKit

class KanbanBoardView: BaseView {
    public var columnWidth: CGFloat = 270 {
        didSet { needsLayout = true }
    }
    
    override var isFlipped: Bool { true }
    public var width: CGFloat {
        CGFloat(subviews.count) * columnWidth
    }
    
    override var intrinsicContentSize: NSSize {
        CGSize(width: width, height: NSView.noIntrinsicMetric)
    }
    
    public func addColumnView(_ columnView: NSView, at index: Int) {
        columnView.frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: bounds.height)
        columnView.autoresizingMask = [.height]
        
        addSubview(columnView)
        frame.size.width = width
    }
}

