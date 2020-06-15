//
//  ClientRepresentation+Convenience.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 26.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct ClientRepresentation: Codable {
    
    let id: Int
    let companyName: String?
    let phone: String?
    let street: String?
    let city: String?
    let state: String?
    let zip: String?
    var projectsArr: [ProjectRepresentation]?
    var projects: String?
    var completed: Bool
}

extension ClientRepresentation: Equatable {
    static func == (lhs: ClientRepresentation, rhs: ClientRepresentation) -> Bool {
        lhs.id != rhs.id
    }
}
