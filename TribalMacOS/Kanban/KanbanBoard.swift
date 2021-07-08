//
//  KanbanBoard.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

class KanbanBoard: NSObject {
    @objc dynamic private var project: Project
    @objc dynamic public var columns: [KanbanColumn]
    
    public init(project: Project) {
        self.project = project
        self.columns = (1...5).map { numColumn in
            KanbanColumn(title: "Column \(numColumn)", tasks: project.tasks.shuffled())
        }
        
        super.init()
    }
}
