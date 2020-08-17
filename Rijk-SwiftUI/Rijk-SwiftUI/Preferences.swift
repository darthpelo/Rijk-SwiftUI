//
//  Preferences.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Foundation

struct Preferences: Codable {
    var key: String
}

extension Preferences {
    static func getKey() throws -> String {
        if let path = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml) {
            return preferences.key
        } else {
            throw NSError(domain: "Failed to get the application preferences", code: 0, userInfo: nil)
        }
    }
}
