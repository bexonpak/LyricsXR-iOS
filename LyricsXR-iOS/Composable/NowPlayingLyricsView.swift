//
//  NowPlayingLyricsView.swift
//  LyricsX - https://github.com/ddddxxx/LyricsX
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import SwiftUI
import ComposableArchitecture
import SFSafeSymbols
import LyricsCore
import MusicPlayer
import LyricsXCore
import LyricsUI

struct NowPlayingLyricsView: View {
  
  @EnvironmentObject
  var coreStore: ViewStore<LyricsXCoreState, LyricsXCoreAction>
  
  @AppStorage("ShowLyricsTranslation")
  var showTranslation = false
  
  @AppStorage("LyricsDescription", store: UserDefaults(suiteName: "group.com.bexonbai.LyricsXR"))
  static var description: String?
  @AppStorage("LyricsTranslation", store: UserDefaults(suiteName: "group.com.bexonbai.LyricsXR"))
  static var translation: String?
  
  @State
  var isAutoScrollEnabled = true
  @State
  var isOnLiveActivities = false
  
  var body: some View {
    VStack {
      if let currentLineIndex = coreStore.progressingState?.currentLineIndex,
         let lyrics = coreStore.progressingState?.lyrics,
         let track = coreStore.playerState.currentTrack {
        LyricsView(isAutoScrollEnabled: $isAutoScrollEnabled, showTranslation: showTranslation)
          .environmentObject(coreStore)
          .mask(FeatherEdgeMask(edges: .vertical, depthPercentage: 0.05))
          .onChange(of: currentLineIndex) { index in
            if #available(iOS 16.1, *) {
              if let line = lyrics.lines[safe: index] {
                LXLiveActivitiesHelpers.shared.update(line)
                NowPlayingLyricsView.description = line.content
                NowPlayingLyricsView.translation = line.attachments.translation()
              } else {
                LXLiveActivitiesHelpers.shared.update(nil)
                NowPlayingLyricsView.description = "..."
                NowPlayingLyricsView.translation = nil
              }
            }
          }
          .onAppear {
            if !isOnLiveActivities {
              isOnLiveActivities = true
              if #available(iOS 16.1, *) {
                LXLiveActivitiesHelpers.shared.start(track)
                NowPlayingLyricsView.description = track.title
                NowPlayingLyricsView.translation = track.artist
              }
            }
          }
      }
      HStack {
        Button(systemSymbol: .textformat) {
          showTranslation.toggle()
        }
        
        if !isAutoScrollEnabled {
          Button(systemSymbol: .rectangleArrowtriangle2Inward) {
            isAutoScrollEnabled = true
          }
        }
        
        Spacer()
      }
      .font(Font.system(.title2))
      .foregroundColor(.white)
      .padding()
    }
    .padding()
    .background(DefaultArtworkImage().dimmed().ignoresSafeArea())
    .environment(\.colorScheme, .dark)
  }
}

import LyricsUIPreviewSupport

struct NowPlayingLyricsView_Previews: PreviewProvider {
  static var previews: some View {
    let viewStore = ViewStore(Store(initialState: PreviewResources.coreState, reducer: lyricsXCoreReducer, environment: .default))
    viewStore.send(.progressingAction(.recalculateCurrentLineIndex))
    return NowPlayingLyricsView()
      .environmentObject(viewStore)
  }
}
