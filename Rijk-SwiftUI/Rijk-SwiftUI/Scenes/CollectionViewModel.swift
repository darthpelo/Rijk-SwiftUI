//
//  CollectionViewModel.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Combine
import Foundation
import Moya
import WidgetKit

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

            self.provider.request(.collection(involvedMaker: "Rembrandt van Rijn", maxResults: 30)) { result in
                DispatchQueue.main.async {
                    WidgetCenter.shared.reloadTimelines(ofKind: "RijkWidget")
                    self.collection = decodeResult(result)
                    self.isFetchInProgress = false
                }
            }
        }
    }
}
