//
//  LXLiveActivitiesLiveActivity.swift
//  LXLiveActivities
//
//  Created by Bexon Pak on 2024-04-19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LXLiveActivitiesAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var description: String
    var translation: String?
  }
  
  var name: String
}

struct LXLiveActivitiesLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LXLiveActivitiesAttributes.self) { context in
      // Lock screen/banner UI goes here
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
            Text("\(context.state.description)")
              .foregroundColor(.white)
              .fontWeight(.black)
              .font(.system(size: 24))
              .opacity(0.8)
            Spacer()
          }
          if let translation = context.state.translation {
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
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.bottom) {
          VStack(alignment: .leading) {
            HStack {
              Text("\(context.state.description)")
                .foregroundColor(.white)
                .fontWeight(.black)
                .font(.system(size: 20))
              Spacer()
            }
            if let translation = context.state.translation {
              HStack {
                Text("\(translation)")
                  .foregroundColor(.white)
                  .font(.system(size: 14))
                Spacer()
              }
            }
          }
          .padding(.horizontal, 20)
        }
      } compactLeading: {
        Image(systemName: "quote.bubble.fill")
      } compactTrailing: {
        
      } minimal: {
        Image(systemName: "quote.bubble.fill")
      }
      .keylineTint(Color.purple)
    }
  }
}

extension LXLiveActivitiesAttributes {
  fileprivate static var preview: LXLiveActivitiesAttributes {
    LXLiveActivitiesAttributes(name: "World")
  }
}

extension LXLiveActivitiesAttributes.ContentState {
  fileprivate static var simple: LXLiveActivitiesAttributes.ContentState {
    LXLiveActivitiesAttributes.ContentState(description: "ひとり上手と呼ばないで\n别说我擅长孤独")
  }
}

#Preview("Notification", as: .content, using: LXLiveActivitiesAttributes.preview) {
  LXLiveActivitiesLiveActivity()
} contentStates: {
  LXLiveActivitiesAttributes.ContentState.simple
}
