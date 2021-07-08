//
//  KanbanViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class KanbanViewController: BaseViewController {
    @objc public let board: KanbanBoard
    private let observations = ObservationBag()
    init(board: KanbanBoard) {
        self.board = board
        super.init()
    }
    
    private lazy var kanbanView = KanbanView()
    public override func loadView() {
        view = kanbanView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observations.observeNew(\.board.columns, in: self, withInitialValue: true) {
            _self, columns in
            _self.kanbanView.boardView.setColumns(columns)
            _self.view.needsLayout = true
        }
    }
}
