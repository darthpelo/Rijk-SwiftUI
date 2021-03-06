//
//  DataFetcher.swift
//  RijkWidgetExtension
//
//  Created by Alessio Roberto on 19/08/2020.
//

import Combine
import Foundation

final class DataFetcher : ObservableObject {

    private var cancellable : Set<AnyCancellable> = Set()

    static let shared = DataFetcher()

    func getCollections(completion: @escaping ([Collection]?) -> Void) {
        let key: String = (try? Preferences.getKey()) ?? ""
        let url = "https://www.rijksmuseum.nl/api/en/collection?key=\(key)&involvedMaker=Rembrandt+van+Rijn&ps=30"
        let urlComponents = URLComponents(string: url)!

        URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map{$0.data}
            .decode(type: ArtObjects.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
        }) { response in
            completion(response.artObjects)
        }
        .store(in: &cancellable)
    }
}

final class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    private var cancellable : Set<AnyCancellable> = Set()

    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString: String) {
        let urlComponents = URLComponents(string: urlString)!

        URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map{$0.data}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            }) { response in
                self.data = response
            }
            .store(in: &cancellable)
    }
}
