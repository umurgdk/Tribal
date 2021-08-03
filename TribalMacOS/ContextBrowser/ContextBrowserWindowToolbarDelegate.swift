//
//  ContextBrowserWindowToolbarDelegate.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import Cocoa

extension NSToolbarItem.Identifier {
    static var search: Self { .init("search") }
    static var insertMenu: Self { .init("createMenu") }
    static var filter: Self { .init("filter") }
    static var displayOptions: Self { .init("displayOptions") }
}

extension NSImage {
    static var plus: NSImage { NSImage(named: NSImage.addTemplateName)! }
    static var filter: NSImage { NSImage(systemSymbolName: "line.horizontal.3.decrease.circle", accessibilityDescription: nil)! }
    static var filterFilled: NSImage { NSImage(systemSymbolName: "line.horizontal.3.decrease.circle.fill", accessibilityDescription: nil)! }
    static var columns: NSImage { NSImage(named: NSImage.columnViewTemplateName)! }
    static var list: NSImage { NSImage(named: NSImage.listViewTemplateName)! }
}

class ContextBrowserWindowToolbarDelegate: NSObject, NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .flexibleSpace,
            .toggleSidebar,
            .sidebarTrackingSeparator,
            .insertMenu,
            .flexibleSpace,
            .displayOptions,
            .filter,
            .search
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .flexibleSpace,
            .space,
            .sidebarTrackingSeparator,
            .insertMenu,
            .filter,
            .displayOptions,
            .search
        ]
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? NSToolbarItem else { return }
        if item.itemIdentifier == .toggleSidebar {
            item.isNavigational = false
        }
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .search:
            return NSSearchToolbarItem(itemIdentifier: .search).configure { $0.searchField = .init() }
            
        case .insertMenu:
            return NSToolbarItem(itemIdentifier: .insertMenu).configure {
                $0.isNavigational = true
                $0.label = "Insert"
                $0.paletteLabel = "Insert"
                $0.view = NSPopUpButton(frame: .zero, pullsDown: true).configure {
                    $0.bezelStyle = .texturedRounded
                    $0.imagePosition = .imageOnly
                    $0.menu = NSMenu.insertMenu().configure {
                        let initilItem = NSMenuItem().configure { $0.image = .plus }
                        $0.insertItem(initilItem, at: 0)
                    }
                }
            }
            
        case .displayOptions:
            return NSToolbarItemGroup(itemIdentifier: .displayOptions,
                                      images: [.columns, .list],
                                      selectionMode: .selectOne,
                                      labels: ["as Columns", "as List"],
                                      target: nil,
                                      action: nil).configure {
                                        $0.controlRepresentation = .collapsed
                                        $0.selectedIndex = 0
                                        $0.label = "Display"
                                        $0.paletteLabel = "Display"
                                      }
            
        case .filter:
            return NSToolbarItem(itemIdentifier: .filter).configure {
                $0.label = "Filter"
                $0.isNavigational = false
                $0.action = Selector(("showFilteringOptions"))
                $0.view = NSButton(image: .filter, target: nil, action: nil).configure {
                    $0.bezelStyle = .texturedRounded
                }
            }
            
        default:
            return nil
        }
    }
}
