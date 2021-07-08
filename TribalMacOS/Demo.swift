//
//  Demo.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

public enum Demo {
    static let bundle: Bundle = {
        let demoBundlePath = Bundle.main.path(forResource: "TribalDemoContent", ofType: "bundle")!
        return Bundle(path: demoBundlePath)!
    }()
    
    static func image(named name: String) -> NSImage {
        bundle.image(forResource: name)!
    }
    
    static func imageURL(named name: String) -> URL {
        bundle.urlForImageResource(name)!
    }
}

// MARK: - Demo Data
extension Demo {
    private static func image(_ index: Int, width: Int = 600, height: Int = 400) -> URL {
        let id = 100 + index
        return URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!
    }
    
    static var tasks: [Task] {
        [
            Task(coverImageURL: image(1),
                 isDone: false,
                 title: "Automatically add all detected names from address book to the list of selected names in contact list (but unchecked)",
                 tags: [],
                 assignee: nil,
                 dueDate: Date()),
                 
            Task(coverImageURL: nil,
                 isDone: false,
                 title: "Hitting reply opens the Recorder with the big pause image in the middle",
                 tags: [],
                 assignee: nil),
            
            Task(coverImageURL: nil,
                 isDone: false,
                 title: "Typing in emails first",
                 tags: [],
                 assignee: nil,
                 dueDate: Date()),
            
            Task(coverImageURL: image(2),
                 isDone: false,
                 title: "Initial tests results, small bugs to be fixed",
                 tags: [],
                 assignee: nil),
            
            Task(coverImageURL: image(3, width: 600, height: 400),
                 isDone: false,
                 title: "Clicking on a push notification opens the recorder AND the player. Should only open the player and play the message you received",
                 tags: [],
                 assignee: nil),
            
            Task(coverImageURL: image(3, width: 600, height: 400),
                 isDone: false,
                 title: "Local file should be played after recording is sent",
                 tags: [],
                 assignee: nil),
        ]
    }
}
