//
//  Project.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

public class Project: NSObject {
    public var title: String
    public var tasks: [Task]
    
    public init(title: String, tasks: [Task] = []) {
        self.title = title
        self.tasks = tasks
    }
}
