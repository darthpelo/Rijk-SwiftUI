//
//  ModelConverter.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Foundation

struct ModelConverter {
    static func convertToModel<T: Equatable & Codable>(from data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }

    static func convertToData<T: Equatable & Codable>(_ model: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(model)
    }

    static func convertToModels<T: Equatable & Codable>(from data: Data) -> [T]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([T].self, from: data)
    }

    static func convertToData<T: Equatable & Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
}
