//
//  SideNavigationView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

class SideNavigationView: BaseView {
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
        $0.floatsGroupRows = false
        $0.rowSizeStyle = .default
    }
    
    lazy var scrollView = NSScrollView().configure {
        $0.drawsBackground = false
    }
    
    override func setupViewHierarchy() {
        additionalSafeAreaInsets = .init(top: 48, left: 0, bottom: 0, right: 0)
        
        scrollView.documentView = sourceList
        sourceList.autosaveExpandedItems = true
        sourceList.autosaveName = "BrowserSideBarSourceList"
        
        addSubview(scrollView)
        addSubview(teamPopupTopDivider)
        addSubview(teamPopupBottomDivider)
        addSubview(teamPopup)
    }
    
    override func layout() {
        super.layout()
        
        let safeRect = safeAreaRect
        
        teamPopupTopDivider.frame = CGRect(x: 0, y: safeRect.maxY-1+additionalSafeAreaInsets.top, width: bounds.width, height: 1)
        teamPopup.frame = CGRect(x: 0, y: teamPopupTopDivider.frame.minY + 1 - 40, width: bounds.width, height: 40)
        teamPopupBottomDivider.frame = CGRect(x: 0, y: teamPopup.frame.minY, width: bounds.width, height: 1)
    
        scrollView.frame = bounds

    }
}
