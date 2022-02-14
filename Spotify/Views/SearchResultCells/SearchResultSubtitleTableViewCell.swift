//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Aybars Acar on 14/2/2022.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {

  static let identifier = "SearchResultSubtitleTableViewCell"
  
  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.numberOfLines = 1
    return label
  }()
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // add subviews
    contentView.addSubview(label)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(iconImageView)
    
    contentView.clipsToBounds = true
    
    // for the little arrow that indicates navigation
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let imageSize: CGFloat = contentView.height - 10
    
    // layout the subviews
    iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
    
    let labelHeight = contentView.height / 2
    
    label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width - iconImageView.right - 15, height: labelHeight)
    
    subtitleLabel.frame = CGRect(x: iconImageView.right + 10, y: label.bottom, width: contentView.width - iconImageView.right - 15, height: labelHeight)
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    label.text = nil
    subtitleLabel.text = nil
    iconImageView.image = nil
  }
  
  // MARK: - public
  
  func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
    label.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
  }

}