//
//  Workspace.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

class Workspace: NSObject {
    @objc dynamic public var projects: [Project]
    public init(projects: [Project] = []) {
        self.projects = projects
    }
}
