//
//  KanbanViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class KanbanViewController: NSViewController {
    lazy var kanbanView = KanbanView()
    var boardView: KanbanBoardView { kanbanView.boardView }
    
    override func loadView() {
        view = kanbanView
    }
    
    var dataSources: [KanbanColumnDataSource] = [
        .init(tasks: Demo.tasks.shuffled()),
        .init(tasks: Demo.tasks.shuffled()),
        .init(tasks: Demo.tasks.shuffled()),
        .init(tasks: Demo.tasks.shuffled()),
        .init(tasks: Demo.tasks.shuffled()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.addColumn(title: "To Do", dataSource: dataSources[0])
        boardView.addColumn(title: "Build / Design Differences", dataSource: dataSources[1])
        boardView.addColumn(title: "In Progress", dataSource: dataSources[2])
        boardView.addColumn(title: "Done", dataSource: dataSources[3])
        boardView.addColumn(title: "Backlog", dataSource: dataSources[4])
    }
}
