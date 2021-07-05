//
//  BrowserMenu.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

extension NSMenu {
    static func insertMenu() -> NSMenu {
        let insertMenu = NSMenu(title: "")
        let taskItem = NSMenuItem(title: "Task...", action: Selector(("insertTask:")), keyEquivalent: "n")
        insertMenu.addItem(taskItem)
        
        return insertMenu
    }
    
    static func displayOptionsMenu() -> NSMenu {
        NSMenu(title: "Display Options").configure {
            let columns = NSMenuItem(title: "as Columns", action: nil, keyEquivalent: "")
            $0.addItem(columns)
            
            let list = NSMenuItem(title: "as List", action: nil, keyEquivalent: "")
            $0.addItem(list)
        }
    }
}
