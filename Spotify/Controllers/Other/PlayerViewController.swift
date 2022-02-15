//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class PlayerViewController: UIViewController {
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .systemBlue
    
    return imageView
  }()
  
  private let controlsView: PlayerControlsView = PlayerControlsView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    // add subviews
    view.addSubview(imageView)
    view.addSubview(controlsView)
    
    controlsView.delegate = self
    
    configureBarButtons()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
    controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
  }
  
  /// to configure the nav bar items
  func configureBarButtons() {
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
  }
  
  /// dismisses the current view
  @objc private func didTapClose() {
    dismiss(animated: true, completion: nil)
  }
  
  /// opens up action sheet
  @objc private func didTapAction() {
    
  }
}


/// handle interaction with the player controls view
extension PlayerViewController: PlayerControlsViewDelegate {
  
  func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
    
  }
  
  func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
    
  }
  
  func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView) {
    
  }
  
  
}
