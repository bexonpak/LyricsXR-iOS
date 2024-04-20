//
//  LXLiveActivities.swift
//  LXLiveActivities
//
//  Created by Bexon Pak on 2024-04-19.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration)
  }
  
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    var entries: [SimpleEntry] = []
    print("===")
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    
    let entry = SimpleEntry(date: currentDate, configuration: configuration)
    entries.append(entry)
    
    
    return Timeline(entries: entries, policy: .atEnd)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct LXLiveActivitiesEntryView : View {
  var entry: Provider.Entry
  @AppStorage("LyricsDescription", store: UserDefaults(suiteName: "group.com.bexonbai.LyricsXR"))
  var description: String?
  @AppStorage("LyricsTranslation", store: UserDefaults(suiteName: "group.com.bexonbai.LyricsXR"))
  var translation: String?
  
  var body: some View {
    ZStack {
      ZStack {
        Color.white
        LinearGradient(
          gradient: Gradient(colors: [Color(#colorLiteral(red: 0.968627451, green: 0.4196078431, blue: 0.1098039216, alpha: 1)), Color(#colorLiteral(red: 0.9921568627, green: 1, blue: 0, alpha: 1))]),
          startPoint: .leading,
          endPoint: .trailing)
        .blendMode(.difference)
        LinearGradient(
          gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9137254902, blue: 0.3725490196, alpha: 1)), Color(#colorLiteral(red: 0.4352941176, green: 0.9490196078, blue: 0, alpha: 1))]),
          startPoint: .bottom,
          endPoint: .top)
        .blendMode(.difference)
        Color.init(white: 0, opacity: 0.2)
      }
      .opacity(0.8)
      .aspectRatio(contentMode: .fill)
      VStack(alignment: .leading) {
        HStack {
          Text("\(description ?? "")")
            .foregroundColor(.white)
            .fontWeight(.black)
            .font(.system(size: 24))
            .opacity(0.8)
          Spacer()
        }
        if let translation = translation {
          HStack {
            Text("\(translation)")
              .foregroundColor(.white)
              .font(.system(size: 16))
              .opacity(0.8)
            Spacer()
          }
          .padding(.top, 1)
        }
      }
      .padding(.horizontal, 20)
    }
    .activitySystemActionForegroundColor(Color.white)
  }
}

struct LXLiveActivities: Widget {
  let kind: String = "LXLiveActivities"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      LXLiveActivitiesEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .contentMarginsDisabled()
  }
}

extension ConfigurationAppIntent {
  fileprivate static var sample: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    
    return intent
  }
}

#Preview(as: .systemLarge) {
  LXLiveActivities()
} timeline: {
  SimpleEntry(date: .now, configuration: .sample)
}
