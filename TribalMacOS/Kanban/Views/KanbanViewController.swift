//
//  KanbanViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class KanbanViewController: BaseViewController {
    @objc dynamic public var board: KanbanBoard!
    private var observations = ObservationBag()
    init(board: KanbanBoard) {
        super.init()
        setValue(board, forKey: "board")
    }
    
    private lazy var kanbanView = KanbanView()
    private lazy var boardViewController = KanbanBoardViewController()
    public override func loadView() {
        view = kanbanView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(boardViewController)
        kanbanView.setContentView(boardViewController.view)
        setupBoard()
        view.needsLayout = true
    }
    
    private func setupBoard() {
        observations = ObservationBag()
        observations.observeNew(\.board.columns, in: self, withInitialValue: true) {
            _self, columns in
            _self.boardViewController.setColumns(columns)
            _self.view.needsLayout = true
        }
    }
}
