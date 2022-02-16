//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit
import SDWebImage

/// to further proxy / delegate the button actions
protocol PlayerViewControllerDelegate: AnyObject {
  
  func didTapPlayPauseButton()
  
  func didTapNextButton()
  
  func didTapBackButton()
  
  func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
  
  weak var dataSource: PlayerDataSource?
  weak var delegate: PlayerViewControllerDelegate?
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
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
    
    configure()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
    controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
  }
  
  func refreshUI() {
    configure()
  }
  
  /// to configure the nav bar items
  private func configureBarButtons() {
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
  }
  
  private func configure() {
    imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
    controlsView.configure(with: PlayerControlsViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
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
  
  func playerControlsView(_ playerControlsView: PlayerControlsView, didUpdateSlider value: Float) {
    delegate?.didSlideSlider(value)
  }
  
  
  func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
    delegate?.didTapPlayPauseButton()
  }
  
  func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
    delegate?.didTapNextButton()
  }
  
  func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView) {
    delegate?.didTapBackButton()
  }
  
  
}
