//
//  AppDelegate.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let workspace = Workspace(projects: [
            Project(title: "Boom macOS", tasks: Demo.tasks.shuffled()),
            Project(title: "Boom iOS", tasks: Demo.tasks.shuffled())
        ])
        
        let browserWC = BrowserWindowController.create(workspace: workspace)
        browserWC.showWindow(self)
        
        WindowCoordinator.shared.add(browserWC)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

