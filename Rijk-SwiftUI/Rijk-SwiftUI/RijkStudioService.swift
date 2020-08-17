//
//  RijkStudioService.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Alamofire
import Foundation
import Moya

enum RijkStudioService {
    case collection(involvedMaker: String)
}

extension RijkStudioService: TargetType {
    var baseURL: URL {
        URL(string: "https://www.rijksmuseum.nl/api/nl")!
    }

    var path: String {
        switch self {
            case .collection:
                return "/collection"
        }
    }

    var method: Moya.Method {
        switch self {
            case .collection:
                return .get
        }
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
            case let .collection(involvedMaker):
                let key: String = (try? Preferences.getKey()) ?? ""
                return .requestParameters(parameters: ["key": key,
                                                       "involvedMaker": involvedMaker],
                                          encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        nil
    }


}
