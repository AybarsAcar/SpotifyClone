//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Aybars Acar on 13/2/2022.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
  static let identifier = "AlbumTrackCollectionViewCell"
  
  private let trackNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.numberOfLines = 0 // wraps the number of lines if it needs to
    return label
  }()
  
  private let artistNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 15, weight: .thin)
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = .secondarySystemBackground
    
    contentView.addSubview(trackNameLabel)
    contentView.addSubview(artistNameLabel)
    
    // to prevent overflowing
    contentView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    trackNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width - 15, height: contentView.height / 2)
    artistNameLabel.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 15, height: contentView.height / 2)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackNameLabel.text = nil
    artistNameLabel.text = nil
  }
  
  
  func configure(with viewModel: AlbumCollectionCellViewModel) {
    trackNameLabel.text = viewModel.name
    artistNameLabel.text = viewModel.artistName
  }
}
