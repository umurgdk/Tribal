//
//  KanbanBoardViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import AppKit

class KanbanBoardViewController: BaseViewController {
    public var columnWidth: CGFloat {
        get { boardView.columnWidth }
        set { boardView.columnWidth = newValue }
    }
    
    private var columnViewControllers: [KanbanColumnViewContoller] = []
    private lazy var boardView = KanbanBoardView()

    override func loadView() {
        view = boardView
    }
    
    public func setColumns(_ columns: [KanbanColumn]) {
        for (column, columnVC) in zip(columns, columnViewControllers) {
            columnVC.column = column
        }
        
        if columns.count < columnViewControllers.count {
            columnViewControllers[columns.count...].forEach { $0.removeFromParent() }
        } else if columns.count > columnViewControllers.count {
            let startingIndex = columnViewControllers.count
            for newColumn in columns[startingIndex...] {
                addColumn(newColumn)
            }
        }
        
        boardView.needsLayout = true
    }
    
    
    public func addColumn(_ column: KanbanColumn) {
        
        let columnVC = KanbanColumnViewContoller(column: column)
        let index = columnViewControllers.count
        
        columnViewControllers.append(columnVC)
        addChild(columnVC)
        boardView.addColumnView(columnVC.view, at: index)
    }
}
