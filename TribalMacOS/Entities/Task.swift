//
//  Task.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

public class Task: NSObject {
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
