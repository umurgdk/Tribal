//
//  SideNavigationDataSource.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import Cocoa

class Section: NSObject {
    let title: String
    var items: [AnyObject]
    
    init(title: String, items: [AnyObject]) {
        self.title = title
        self.items = items
    }
}

class Project: NSObject {
    let title: String
    init(title: String) {
        self.title = title
    }
}

class SideNavigationDataSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    let projectsSection = Section(title: "Projects", items: [
        Project(title: "Boom macOS"),
        Project(title: "Boom iOS")
    ])
    
    lazy var sections = [projectsSection]
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return sections.count
        }
        
        if let section = item as? Section {
            return section.items.count
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return sections[index]
        }
        
        if let section = item as? Section {
            return section.items[index]
        }
        
        fatalError()
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        self.outlineView(outlineView, isGroupItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let _ = item as? Section {
            return true
        }
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let section = item as? Section {
            let sectionLabel = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("section"), owner: nil) as? NSTextField ?? NSTextField(labelWithString: "").configure {
                $0.textColor = .tertiaryLabelColor
                $0.identifier = NSUserInterfaceItemIdentifier("section")
            }
            
            sectionLabel.stringValue = section.title
            return sectionLabel
        } else if let project = item as? Project {
            let cell = outlineView.makeView(NavigationItemCell.self, owner: nil)
            cell.iconView.image = NSImage(systemSymbolName: "folder", accessibilityDescription: nil)
            cell.titleLabel.stringValue = project.title
            return cell
        }
        
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, tintConfigurationForItem item: Any) -> NSTintConfiguration? {
        .monochrome
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let _ = item as? Section {
            return false
        }
        
        return true
    }
    
    // func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    //     28
    // }
}

class NavigationSectionTextField: NSTextField, UserInterfaceIdentifiable {
    override class var cellClass: AnyClass? {
        get { NSTableHeaderCell.self }
        set { super.cellClass = newValue }
    }
}

class NavigationItemCell: NSTableCellView, UserInterfaceIdentifiable {
    let titleLabel = NSTextField(labelWithString: "").configure {
        $0.lineBreakMode = .byTruncatingMiddle
    }
    
    let iconView = NSImageView()
    
    
    override func layout() {
        if iconView.superview == nil {
            imageView = iconView
            textField = titleLabel
            
            addSubview(iconView)
            addSubview(titleLabel)
        }
        
        super.layout()
        
        iconView.sizeToFit()
        iconView.setFrameOrigin(NSPoint(x: 1, y: bounds.midY - iconView.bounds.height / 2))
        
        titleLabel.sizeToFit()
        var titleFrame = titleLabel.frame
        titleFrame.origin.x = iconView.frame.maxX + 4
        titleFrame.origin.y = (bounds.midY - titleLabel.frame.height / 2)
        titleFrame.size.width = bounds.width - 8 - titleFrame.minX
        titleLabel.frame = titleFrame
    }
}
