//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Aybars Acar on 15/2/2022.
//

import Foundation
import UIKit

/// to handle the button clicks in our controller from the owner view controller
protocol PlayerControlsViewDelegate: AnyObject {
  
  func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
  
  func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView)
  
  func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView)

  func playerControlsView(_ playerControlsView: PlayerControlsView, didUpdateSlider value: Float)
}

final class PlayerControlsView: UIView {
  
  weak var delegate: PlayerControlsViewDelegate?
  
  private let volumeSlider: UISlider = {
    let slider = UISlider()
    slider.value = 0.5
    return slider
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "This is a song"
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = "Artist Name"
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.tintColor = .label
    
    let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.tintColor = .label
    
    let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private let playPauseButton: UIButton = {
    let button = UIButton()
    button.tintColor = .label
    
    let pauseImage = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .bold))
    button.setImage(pauseImage, for: .normal)
    
    return button
  }()
  
  private var isPlaying = true
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    // add subviews
    addSubview(nameLabel)
    addSubview(subtitleLabel)
    addSubview(volumeSlider)
    addSubview(backButton)
    addSubview(nextButton)
    addSubview(playPauseButton)
    
    // assign slider action
    volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
    
    // assign button clicks
    backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
    
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
    subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom + 10, width: width, height: 50)
    
    volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)
    
    let buttonSize: CGFloat = 60
    playPauseButton.frame = CGRect(x: (width - buttonSize) / 2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)
    backButton.frame = CGRect(x: playPauseButton.left - 60 - buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    nextButton.frame = CGRect(x: playPauseButton.right + 60, y: playPauseButton.top, width: buttonSize, height: buttonSize)
  }
  
  func configure(with viewModel: PlayerControlsViewModel) {
    nameLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
  }
  
  // MARK: - Button clicks
  
  @objc private func didTapBackButton() {
    delegate?.playerControlsViewDidTapBackButton(self)
  }
  
  @objc private func didTapNextButton() {
    delegate?.playerControlsViewDidTapNextButton(self)
  }
  
  @objc private func didTapPlayPauseButton() {
    self.isPlaying.toggle()
    delegate?.playerControlsViewDidTapPlayPauseButton(self)
    
    let pauseImage = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .bold))
    let playImage = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .bold))
    
    // update the icon
    playPauseButton.setImage(isPlaying ? pauseImage : playImage, for: .normal)
  }
  
  // MARK: - Slider
  
  @objc func didSlideSlider(_ slider: UISlider) {
    let value = slider.value
    
    delegate?.playerControlsView(self, didUpdateSlider: value)
  }
}
