//
//  KanbanColumnViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class KanbanColumnViewContoller: BaseViewController {
    @objc public var column: KanbanColumn {
        didSet { setupColumn() }
    }
    
    public init(column: KanbanColumn) {
        self.column = column
        super.init()
    }
    
    private lazy var dataSource = KanbanColumnDataSource()
    private lazy var columnView = KanbanColumnView()
    public override func loadView() {
        view = columnView
        columnView.dataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColumn()
    }
    
    private func setupColumn() {
        columnView.title = column.title
        dataSource.tasks = column.tasks
    }
}
