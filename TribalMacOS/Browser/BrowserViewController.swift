//
//  BrowserViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class BrowserViewController: BaseViewController {
    @objc public let browserController: BrowserController
    init(browserController: BrowserController) {
        self.browserController = browserController
        super.init()
    }
    
    private lazy var splitController = NSSplitViewController().configure {
        let sideBarItem = NSSplitViewItem(sidebarWithViewController: sideNavigationController)
        sideBarItem.titlebarSeparatorStyle = .none
        sideBarItem.minimumThickness = 250
        $0.minimumThicknessForInlineSidebars = 200
        $0.addSplitViewItem(sideBarItem)
        
        let kanbanItem = NSSplitViewItem(viewController: contentViewController)
        kanbanItem.titlebarSeparatorStyle = .none
        $0.addSplitViewItem(kanbanItem)
    }
    
    private let observations = ObservationBag()
    private lazy var contentViewController = BrowserContentViewController()
    private lazy var sideNavigationController = SideNavigationController(browserController: browserController)
    
    public override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layerContentsRedrawPolicy = .never
        
        addChild(splitController)
        view.addSubview(splitController.view)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        observations.observeNew(\.browserController.selectedProject, in: self, withInitialValue: true) {
            _self, project in
            _self.selectedProjectDidChange(project)
        }
    }
    
    public override func viewDidLayout() {
        super.viewDidLayout()
        splitController.view.frame = view.bounds
    }
    
    private func selectedProjectDidChange(_ project: Project?) {
        guard let project = project else { return }
        
        let board = KanbanBoard(project: project)
        let kanbanViewController = KanbanViewController(board: board)
        contentViewController.presentViewController(kanbanViewController)
    }
}
