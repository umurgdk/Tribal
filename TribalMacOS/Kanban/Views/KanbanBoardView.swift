//
//  KanbanBoardView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit
import SnapKit

class KanbanBoardView: BaseView {
    var columnWidth: CGFloat = 270 {
        didSet { needsLayout = true }
    }
    
    var columns: [KanbanColumnView] = []
    func addColumn(title: String, dataSource: KanbanColumnDataSource) {
        let columnView = KanbanColumnView()
        columnView.title = title
        columnView.dataSource = dataSource
        columnView.columnWidth = columnWidth

        let index = columns.count
        columnView.frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: bounds.height)
        columnView.autoresizingMask = [.height]
        columns.append(columnView)
        
        addSubview(columnView)
        frame.size.width = width
    }
    
    var width: CGFloat {
        CGFloat(columns.count) * columnWidth
    }
    
    override var intrinsicContentSize: NSSize {
        CGSize(width: width, height: NSView.noIntrinsicMetric)
    }
}
