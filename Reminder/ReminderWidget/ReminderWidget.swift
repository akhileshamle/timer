//
//  ReminderWidget.swift
//  ReminderWidget
//
//  Created by Akhilesh Amle on 02/05/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ReminderWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Color.pink
            Text(entry.date, style: .time)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.pink)
            Text(entry.date, style: .date)
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(.pink)
            Color.pink
        }
        
    }
}

@main
struct ReminderWidget: Widget {
    let kind: String = "ReminderWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Reminder")
        .description("Plays a sound after each time interval.")
    }
}

struct ReminderWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReminderWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
