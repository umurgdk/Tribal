//
//  Entities.swift
//  TribalCore
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

public struct Task {
    public let coverImageURL: URL?
    public let isDone: Bool
    public let title: String
    public let tags: [TaskTag]
    public let assignee: Profile?
    public let dueDate: Date?
    
    public init(coverImageURL: URL?, isDone: Bool, title: String, tags: [TaskTag], assignee: Profile?, dueDate: Date? = nil) {
        self.coverImageURL = coverImageURL
        self.isDone = isDone
        self.title = title
        self.tags = tags
        self.assignee = assignee
        self.dueDate = dueDate
    }
}

public struct TaskTag {
    public let id: String
    public let color: NSColor
    
    public init(id: String, color: NSColor) {
        self.id = id
        self.color = color
    }
}

public struct Profile {
    public let id = UUID()
    public let name: String
    public let imageURL: URL?
    
    public init(name: String, imageURL: URL?) {
        self.name = name
        self.imageURL = imageURL
    }
}
