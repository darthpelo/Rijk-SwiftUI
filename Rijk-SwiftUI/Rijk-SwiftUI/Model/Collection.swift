//
//  Collection.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Foundation

struct ArtObjects: Codable {
    var artObjects: [Collection]
}

extension ArtObjects: Equatable {
    static func == (lhs: ArtObjects, rhs: ArtObjects) -> Bool {
        return lhs.artObjects == rhs.artObjects
    }
}

struct Collection: Codable, Identifiable {
    var id: String
    var title: String
}

extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.id == rhs.id
    }
}
