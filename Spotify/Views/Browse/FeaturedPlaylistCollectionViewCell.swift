//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
  static let identifier = "FeaturedPlaylistCollectionViewCell"
  
  private let playlistCoverImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "photo")
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 4
    return imageView
  }()
  
  private let playlistNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.numberOfLines = 0 // wraps the number of lines if it needs to
    return label
  }()
  
  private let creatorNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 15, weight: .thin)
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(playlistCoverImageView)
    contentView.addSubview(playlistNameLabel)
    contentView.addSubview(creatorNameLabel)
    
    // to prevent overflowing
    contentView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    creatorNameLabel.frame = CGRect(x: 3, y: contentView.height - 30, width: contentView.width - 6, height: 30)
    playlistNameLabel.frame = CGRect(x: 3, y: contentView.height - 60, width: contentView.width - 6, height: 30)
    
    let imageSize = contentView.height - 70
    playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize) / 2, y: 3, width: imageSize, height: imageSize)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    playlistNameLabel.text = nil
    creatorNameLabel.text = nil
    playlistCoverImageView.image = nil
  }
  
  
  func configure(with viewModel: FeaturedPlaylistCellViewModel) {
    playlistNameLabel.text = viewModel.name
    creatorNameLabel.text = viewModel.creatorName
    playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
  }
}
