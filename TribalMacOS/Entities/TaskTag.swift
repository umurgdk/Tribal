//
//  TaskTag.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

public class TaskTag {
    public let id: String
    public let color: NSColor
    
    public init(id: String, color: NSColor) {
        self.id = id
        self.color = color
    }
}
