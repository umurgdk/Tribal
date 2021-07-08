//
//  KanbanColumnViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class KanbanColumnViewContoller: BaseViewController {
    public let column: KanbanColumn
    public init(column: KanbanColumn) {
        self.column = column
        super.init()
    }
    
    private lazy var columnView = KanbanColumnView()
    public override func loadView() {
        view = columnView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
