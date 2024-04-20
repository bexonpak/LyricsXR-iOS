//
//  LXLiveActivitiesAttributes.swift
//  LyricsXR-iOS
//
//  Created by Bexon Pak on 2024-04-19.
//

import ActivityKit
import LyricsCore
import WidgetKit
import MusicPlayer

struct LXLiveActivitiesAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var description: String
    var translation: String?
  }
  
  var name: String
}

@available(iOS 16.1, *)
class LXLiveActivitiesHelpers {
  
  static let shared = LXLiveActivitiesHelpers()
  
  func start(_ musicTrack: MusicTrack) {
    Task {
      let liveActivitiesAttributes = LXLiveActivitiesAttributes(name: "")
      let initialContentState = LXLiveActivitiesAttributes.ContentState(description: musicTrack.title ?? "...")

      do {
        let activity = try Activity<LXLiveActivitiesAttributes>.request(
          attributes: liveActivitiesAttributes,
          contentState: initialContentState,
          pushType: nil)
        WidgetCenter.shared.reloadTimelines(ofKind: "LXLiveActivities")
        print("Requested Live Activity")
      } catch (let error) {
        print("Error requesting Live Activity \(error.localizedDescription)")
      }
    }
  }
  
  func update(_ line: LyricsLine?) {
    Task {
      var updatedStatus = LXLiveActivitiesAttributes.ContentState(description: "")
      guard let line = line else {
        for activity in Activity<LXLiveActivitiesAttributes>.activities{
          await activity.update(using: updatedStatus)
        }
        return
      }
      updatedStatus = LXLiveActivitiesAttributes.ContentState(
        description: line.content,
        translation: line.attachments.translation()
      )
      
      for activity in Activity<LXLiveActivitiesAttributes>.activities{
        await activity.update(using: updatedStatus)
      }
      WidgetCenter.shared.reloadTimelines(ofKind: "LXLiveActivities")
    }
  }
  
  func stop() {
    Task {
      for activity in Activity<LXLiveActivitiesAttributes>.activities{
        await activity.end(dismissalPolicy: .immediate)
      }
    }
  }
  
}
