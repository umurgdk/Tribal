//
//  Team.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 15.07.2021.
//

import Foundation

class Team: NSObject {
    let id: String
    let name: String
    var parent: Team?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
