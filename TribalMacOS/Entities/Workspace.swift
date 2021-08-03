//
//  Workspace.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

public class Workspace: NSObject {
    @objc dynamic public var projects: [Project]
    public let id: String
    public let context: EntityContext
    public init(context: EntityContext, id: String, projects: [Project] = []) {
        self.id = id
        self.context = context
        self.projects = projects
    }
}
