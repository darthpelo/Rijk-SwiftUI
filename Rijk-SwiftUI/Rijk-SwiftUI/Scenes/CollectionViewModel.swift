//
//  CollectionViewModel.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Combine
import Foundation
import Moya

protocol CollectionViewModelInterface {
    func data()
}

final class CollectionViewModel: ObservableObject, CollectionViewModelInterface {
    @Published var collection: [Collection] = []
    @Published var isFetchInProgress = false

    private let provider: MoyaProvider<RijkStudioService>

    init(provider: MoyaProvider<RijkStudioService> = MoyaProvider<RijkStudioService>()) {
        self.provider = provider
    }

    func data() {
        isFetchInProgress = true

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            self.provider.request(.collection(involvedMaker: "Rembrandt van Rijn")) { result in
                DispatchQueue.main.async {
                    self.collection = self.decodeResult(result)
                    print(self.collection.count)
                    self.isFetchInProgress = false
                }
            }
        }
    }

    // MARK: - Private

    private func decodeResult(_ result: Result<Response, MoyaError>) -> [Collection] {
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
}

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
