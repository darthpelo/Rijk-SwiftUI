//
//  RijkWidget.swift
//  RijkWidget
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Combine
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CollectionEntry {
        CollectionEntry(date: Date(), title: "A scholar in his study")
    }

    func getSnapshot(in context: Context, completion: @escaping (CollectionEntry) -> ()) {
        let entry = CollectionEntry(date: Date(), title: "A scholar in his study")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        DataFetcher.shared.getCollections { response in

            let date = Date()
            let calendar = Calendar.current

            let entries = response?.enumerated().map { offset, currentCollection in
                CollectionEntry(date: calendar.date(byAdding: .second, value: offset*10, to: date)!, title: currentCollection.title ?? "...")
            }

            let timeLine = Timeline(entries: entries ?? [], policy: .after(refreshDate))

            completion(timeLine)
        }
    }

}

struct CollectionEntry: TimelineEntry {
    let date: Date
    let title: String
}

struct RijkWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(.black))
            VStack {
                Text(entry.title)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
                UpdateView(date: entry.date)
            }
        }
    }
}

struct UpdateView: View {
    var date: Date
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(.white))
            HStack {
                Text("Last update: ")
                    .font(.footnote)
                Text(date, style: .time)
                    .font(.footnote)
            }
        }.padding(15)
    }
}


@main
struct RijkWidget: Widget {
    let kind: String = "RijkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RijkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Rijk Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
        .onBackgroundURLSessionEvents {
                (sessionIdentifier, competion) in
            competion()
            }
    }
}

struct RijkWidget_Previews: PreviewProvider {
    static var previews: some View {
        RijkWidgetEntryView(entry: CollectionEntry(date: Date(), title: "Self-Portrait"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

public class DataFetcher : ObservableObject {

    var cancellable : Set<AnyCancellable> = Set()

    static let shared = DataFetcher()

    func getCollections(completion: @escaping ([Collection]?) -> Void){
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
