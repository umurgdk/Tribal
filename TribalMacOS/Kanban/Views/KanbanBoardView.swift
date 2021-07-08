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
    
    public private(set) var columns: [KanbanColumn] = []
    private var dataSources: [KanbanColumnDataSource] = []
    private var columnViews: [KanbanColumnView] = []
    
    public func setColumns(_ columns: [KanbanColumn]) {
        columnViews.forEach { $0.removeFromSuperview() }
        self.columns = columns
        
        columns.forEach(addColumn(_:))
        needsLayout = true
    }
    
    override var isFlipped: Bool { true }
    public func addColumn(_ column: KanbanColumn) {
        let dataSource = KanbanColumnDataSource(tasks: column.tasks)
        dataSources.append(dataSource)
        
        let columnView = KanbanColumnView()
        columnView.title = column.title
        columnView.dataSource = dataSource
        columnView.columnWidth = columnWidth

        let index = columnViews.count
        columnView.frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: bounds.height)
        columnView.autoresizingMask = [.height]
        columnViews.append(columnView)
        
        addSubview(columnView)
        frame.size.width = width
    }
    
    public var width: CGFloat {
        CGFloat(columnViews.count) * columnWidth
    }
    
    public override var intrinsicContentSize: NSSize {
        CGSize(width: width, height: NSView.noIntrinsicMetric)
    }
}
