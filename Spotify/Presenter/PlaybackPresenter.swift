//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Aybars Acar on 15/2/2022.
//

import Foundation
import UIKit

final class PlaybackPresenter {
  
  /// handles playing a track
  static func startPlayback(from viewController: UIViewController, track: AudioTrack) {
    let vc = PlayerViewController()
    
    // give a nav title
    vc.title = track.name
    
    viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
  
  /// handles playing all the tracks in the entire album or playlist
  static func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
    let vc = PlayerViewController()
    
    viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
  }
}
