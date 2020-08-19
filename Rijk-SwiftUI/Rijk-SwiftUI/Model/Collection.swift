//
//  Collection.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Foundation
import Moya

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
    var objectNumber: String
    var title: String
}

extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.id == rhs.id && lhs.objectNumber == rhs.objectNumber
    }
}

func decodeResult(_ result: Result<Response, MoyaError>) -> [Collection] {
    switch result {
        case let .success(response):
            if response.statusCode == 200,
               let object: ArtObjects = ModelConverter.convertToModel(from: response.data) {
                return object.artObjects
            } else {
                return []
            }
        case .failure:
            return []
    }
}
