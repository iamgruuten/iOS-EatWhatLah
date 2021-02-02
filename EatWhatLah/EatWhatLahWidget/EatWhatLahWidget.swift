//
//  EatWhatLahWidget.swift
//  EatWhatLahWidget
//
//  Created by Apple on 2/2/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),venueName: "" ,configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), venueName: "",configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let userDefaults = UserDefaults(suiteName: "group.widgetdatapass")

        let venue = userDefaults?.value(forKey: "venue") ?? "No Places Yet"
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, venueName: venue as! String, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let venueName : String
    let configuration: ConfigurationIntent
}

struct EatWhatLahWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            
            GeometryReader {
                geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Text("You are heading to").font(
                Font.system(size: 12, weight: .heavy, design: .default))
            
            Text(entry.venueName).font(
                Font.system(size: 24, weight: .heavy, design: .default))
            
        }
    }
}

@main
struct EatWhatLahWidget: Widget {
    let kind: String = "EatWhatLahWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            EatWhatLahWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct EatWhatLahWidget_Previews: PreviewProvider {
    static var previews: some View {
        EatWhatLahWidgetEntryView(entry: SimpleEntry(date: Date(),venueName: "" ,configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
