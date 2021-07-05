//
//  SideNavigationController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit


class SideNavigationController: NSViewController {
    lazy var teamPopupTopDivider = NSBox.divider()
    lazy var teamPopupBottomDivider = NSBox.divider()
    
    lazy var teamPopup = Popup().configure {
        $0.header = "Teams"
        $0.title = "Umur Gedik"
        $0.image = Demo.image(named: "umur")
    }
    
    lazy var sourceList = NSOutlineView().configure {
        $0.selectionHighlightStyle = .sourceList
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("column"))
        $0.addTableColumn(column)
        $0.headerView = nil
        $0.backgroundColor = .clear
        $0.dataSource = navigationDataSource
        $0.delegate = navigationDataSource
        $0.floatsGroupRows = false
        $0.rowSizeStyle = .default
    }
    
    lazy var navigationDataSource = SideNavigationDataSource()
    
    lazy var scrollView = NSScrollView().configure {
        $0.drawsBackground = false
    }
    
    override func loadView() {
        view = NSView()
        
        scrollView.documentView = sourceList
        view.additionalSafeAreaInsets = .init(top: 48, left: 0, bottom: 0, right: 0)
        sourceList.autosaveExpandedItems = true
        sourceList.autosaveName = "BrowserSideBarSourceList"
        
        view.addSubview(scrollView)
        view.addSubview(teamPopupTopDivider)
        view.addSubview(teamPopupBottomDivider)
        view.addSubview(teamPopup)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceList.expandItem(navigationDataSource.projectsSection)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        let bounds = view.bounds
        let safeRect = view.safeAreaRect
        
        teamPopupTopDivider.frame = CGRect(x: 0, y: safeRect.maxY-1+view.additionalSafeAreaInsets.top, width: bounds.width, height: 1)
        teamPopup.frame = CGRect(x: 0, y: teamPopupTopDivider.frame.minY + 1 - 40, width: bounds.width, height: 40)
        teamPopupBottomDivider.frame = CGRect(x: 0, y: teamPopup.frame.minY, width: bounds.width, height: 1)
    
        scrollView.frame = view.bounds
    }
}
