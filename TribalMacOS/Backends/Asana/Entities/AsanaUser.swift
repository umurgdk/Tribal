//
//  AsanaUser.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

struct AsanaUser: Codable {
    let gid: String
    let email: String
    let name: String
    let photo: [ProfilePictureSize: URL]
    let workspaces: [WorkspaceSummary]
    
    enum ProfilePictureSize: String, Codable {
        case tiny = "image_21x21"
        case small = "image_27x27"
        case regular = "image_36x36"
        case medium = "image_60x60"
        case large = "image_128x128"
    }
    
    struct WorkspaceSummary: Codable {
        let gid: String
        let name: String
    }
}
