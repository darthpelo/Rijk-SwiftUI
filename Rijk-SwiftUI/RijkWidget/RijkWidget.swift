//
//  RijkWidget.swift
//  RijkWidget
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Moya
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let provider = MoyaProvider<RijkStudioService>()
    
    func placeholder(in context: Context) -> CollectionEntry {
        CollectionEntry(date: Date(), title: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (CollectionEntry) -> ()) {
        let entry = CollectionEntry(date: Date(), title: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        provider.request(.collection(involvedMaker: "Rembrandt van Rijn", maxResults: 1)) { result in
            WidgetCenter.shared.reloadAllTimelines()
            
            guard let collections = decodeResult(result).first else {
                assertionFailure()
                return
            }

            let entry = CollectionEntry(date: currentDate, title: collections.title)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct CollectionEntry: TimelineEntry {
    let date: Date
    let title: String

    var relevance: TimelineEntryRelevance? {
            return TimelineEntryRelevance(score: 90) // 0 - not important | 100 - very important
        }
}

struct RijkWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.title).padding()
            Text(entry.date, style: .time).padding()
        }
    }
}

@main
struct RijkWidget: Widget {
    let kind: String = "RijkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RijkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct RijkWidget_Previews: PreviewProvider {
    static var previews: some View {
        RijkWidgetEntryView(entry: CollectionEntry(date: Date(), title: "sajdoijdoi"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
