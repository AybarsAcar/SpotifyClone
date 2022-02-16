//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Aybars Acar on 15/2/2022.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {

  var songName: String? { get }
  var subtitle: String? { get }
  var imageURL: URL? { get }
}

final class PlaybackPresenter {
  
  static let shared = PlaybackPresenter()
  private init() { }
  
  private var track: AudioTrack?
  private var tracks = [AudioTrack]()
  
  var currentTrack: AudioTrack? {
    if let track = track, tracks.isEmpty {
      return track
    }
    
    else if let player = self.playerQueue, !tracks.isEmpty {
      let item = player.currentItem
      let items = player.items()
      
      guard let index = items.firstIndex(where: { $0 == item }) else {
        return nil
      }
      
      return tracks[index]
    }
    
    return nil
  }
  
  var player: AVPlayer?
  var playerQueue: AVQueuePlayer?
  
  /// handles playing a track
  func startPlayback(from viewController: UIViewController, track: AudioTrack) {
    
    guard let url = URL(string: track.previewURL ?? "") else { return }
    
    player = AVPlayer(url: url)
    player?.volume = 0.5
    
    self.tracks = []
    self.track = track
    
    let vc = PlayerViewController()
    
    // give a nav title
    vc.title = track.name
    vc.dataSource = self
    vc.delegate = self
    
    viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
      // play the audio when presenting the view controller is complete
      self?.player?.play()
    }
  }
  
  /// handles playing all the tracks in the entire album or playlist
  func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
    
    self.tracks = tracks
    self.track = nil
    
    let items: [AVPlayerItem] = tracks.compactMap({ item in
      guard let url = URL(string: item.previewURL ?? "") else { return nil }
      return AVPlayerItem(url: url)
    })
    
    self.playerQueue = AVQueuePlayer(items: items)
    
    self.playerQueue?.volume = 0.5
    
    
    let vc = PlayerViewController()
    vc.dataSource = self
    vc.delegate = self

    viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
      self?.playerQueue?.play()
    }
  }
}


extension PlaybackPresenter: PlayerDataSource {
  
  var songName: String? {
    return currentTrack?.name
  }
  
  var subtitle: String? {
    return currentTrack?.artists.first?.name
  }
  
  var imageURL: URL? {
    return URL(string: currentTrack?.album?.images.first?.url ?? "")
  }
  
}


extension PlaybackPresenter: PlayerViewControllerDelegate {
  
  func didSlideSlider(_ value: Float) {
    player?.volume = value
  }
  
  
  func didTapPlayPauseButton() {
    if let player = player {
      
      // if we are currently playing
      if player.timeControlStatus == .playing {
        player.pause()
      }
      
      else if player.timeControlStatus == .paused {
        player.play()
      }
    }
    
    else if let player = playerQueue {
      // if we are currently playing
      if player.timeControlStatus == .playing {
        player.pause()
      }
      
      else if player.timeControlStatus == .paused {
        player.play()
      }
    }
  }
  
  func didTapNextButton() {
    if tracks.isEmpty {
      // not playlist or album
      player?.pause()
    }
    else if let player = playerQueue {
      // go to the next track
      player.advanceToNextItem()
    }
  }
  
  func didTapBackButton() {
    if tracks.isEmpty {
      // not playlist or album
      player?.pause()
      player?.play() // play again
    }
    else if let item = playerQueue?.items().first {
      // go to the next track
      playerQueue?.pause()
      playerQueue?.removeAllItems()
      playerQueue = AVQueuePlayer(items: [item])
      
      playerQueue?.play()
      playerQueue?.volume = 0.5
    }
  }
  
}
