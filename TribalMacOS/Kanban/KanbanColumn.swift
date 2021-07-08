//
//  KanbanColumn.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

protocol KanbanColumnObserver: AnyObject {
    func kanbanColumn(_ column: KanbanColumn, didChangeTitle title: String)
    func kanbanColumn(_ column: KanbanColumn, didChangeTasks tasks: [Task])
}

class KanbanColumn: NSObject {
    public var title: String {
        didSet { forEachObserver { $0.kanbanColumn(self, didChangeTitle: title) } }
    }
    
    public var tasks: [Task] {
        didSet { forEachObserver { $0.kanbanColumn(self, didChangeTasks: tasks) } }
    }
    
    init(title: String, tasks: [Task] = []) {
        self.title = title
        self.tasks = tasks
        super.init()
    }
    
    // MARK: - Observable
    var observations: [ObjectIdentifier: Observation] = [:]
    struct Observation {
        weak var observer: KanbanColumnObserver?
    }
    
    func addObserver(_ observer: KanbanColumnObserver) {
        let identifier = ObjectIdentifier(observer)
        let observation = Observation(observer: observer)
        observations[identifier] = observation
    }
    
    func removeObserver(_ observer: KanbanColumnObserver) {
        let identifier = ObjectIdentifier(observer)
        observations.removeValue(forKey: identifier)
    }
    
    func forEachObserver(_ block: (KanbanColumnObserver) -> Void) {
        observations.values.lazy.compactMap { $0.observer }.forEach(block)
    }
}
