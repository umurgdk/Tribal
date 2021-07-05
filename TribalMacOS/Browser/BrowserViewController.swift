//
//  BrowserViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class BrowserViewController: NSViewController {
    lazy var splitController = NSSplitViewController().configure {
        let sideBarItem = NSSplitViewItem(sidebarWithViewController: sideNavigationController)
        sideBarItem.titlebarSeparatorStyle = .none
        sideBarItem.minimumThickness = 250
        $0.minimumThicknessForInlineSidebars = 200
        $0.addSplitViewItem(sideBarItem)
        
        let kanbanItem = NSSplitViewItem(viewController: kanbanViewController)
        kanbanItem.titlebarSeparatorStyle = .none
        $0.addSplitViewItem(kanbanItem)
    }
    
    let kanbanViewController = KanbanViewController()
    let sideNavigationController = SideNavigationController()
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layerContentsRedrawPolicy = .never
        
        addChild(splitController)
        view.addSubview(splitController.view)
        
        splitController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
