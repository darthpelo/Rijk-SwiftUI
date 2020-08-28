//
//  RijkWidget.swift
//  RijkWidget
//
//  Created by Alessio Roberto on 17/08/2020.
//

import Combine
import WidgetKit
import SwiftUI

@main
struct RijkWidget: Widget {
    let kind: String = "RijkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RijkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Rijk Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CollectionEntry {
        CollectionEntry(date: Date(), title: "A scholar in his study", url: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (CollectionEntry) -> ()) {
        let entry = CollectionEntry(date: Date(), title: "A scholar in his study", url: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        DataFetcher.shared.getCollections { response in

            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

            let calendar = Calendar.current

            let entries = response?.enumerated().map { offset, currentCollection in
                CollectionEntry(date: calendar.date(byAdding: .second,
                                                    value: offset * 30,
                                                    to: currentDate)!,
                                title: currentCollection.title,
                                url: currentCollection.webImage.url)
            }

            let timeLine = Timeline(entries: entries ?? [],
                                    policy: .after(refreshDate))

            completion(timeLine)
        }
    }

}

struct CollectionEntry: TimelineEntry {
    let date: Date
    let title: String
    let url: String
}

struct RijkWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(.black))
            VStack {
                Text(entry.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .foregroundColor(.white)
                    .font(.body)
                if widgetFamily == .systemLarge {
                    ImageView(withURL: entry.url)
                }
                UpdateView(date: entry.date)
            }.padding()
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
                    .foregroundColor(.gray)
                Text(date, style: .time)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }.padding(35)
    }
}

struct RijkWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RijkWidgetEntryView(entry: CollectionEntry(date: Date(), title: "Self-Portrait, asihds sladjoaisjd lsadjoiajd pippeorolkndslkfnslkdfn asdklhaosdn", url: ""))
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            RijkWidgetEntryView(entry: CollectionEntry(date: Date(), title: "Self-Portrait, asihds sladjoaisjd lsadjoiajd pippeorolkndslkfnslkdfn asdklhaosdn", url: ""))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
