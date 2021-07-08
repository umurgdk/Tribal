//
//  BrowserController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

class BrowserController: NSObject {
    public static let selectedProjectKeyPath = "selectedProject"
    public static let selectedTaskPath = "selectedTask"
    
    @objc dynamic public let workspace: Workspace
    @objc dynamic public var selectedProject: Project?
    @objc dynamic public var selectedTask: Task?
    
    public init(workspace: Workspace) {
        self.workspace = workspace
        selectedProject = workspace.projects.last
        super.init()
    }
}
