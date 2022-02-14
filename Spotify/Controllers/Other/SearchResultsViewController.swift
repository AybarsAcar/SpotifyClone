//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

struct SearchSection {
  let title: String
  let results: [SearchResult]
}

/// to handle navigation from parent
protocol SearchResultsViewControllerDelegate: AnyObject {
  func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
  
  weak var delegate: SearchResultsViewControllerDelegate?
  
  private var sections = [SearchSection]()
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    // register cells types
    tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
    tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
    
    tableView.backgroundColor = .systemBackground
    tableView.isHidden = true
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    
    // register tableview
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
 
  func update(with results: [SearchResult]) {
    
    let artists = results.filter({
      switch $0 {
      case .artist: return true
      default: return false
      }
    })
    
    let tracks = results.filter({
      switch $0 {
      case .track: return true
      default: return false
      }
    })
    
    let albums = results.filter({
      switch $0 {
      case .album: return true
      default: return false
      }
    })
    
    let playlists = results.filter({
      switch $0 {
      case .playlist: return true
      default: return false
      }
    })
    
    self.sections = [
      SearchSection(title: "Songs", results: tracks),
      SearchSection(title: "Artists", results: artists),
      SearchSection(title: "Playlists", results: playlists),
      SearchSection(title: "Albums", results: albums)
    ]
    
    tableView.reloadData()
    
    tableView.isHidden = results.isEmpty
    
  }
}


extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = sections[indexPath.section].results[indexPath.row]
        
    switch result {
      
    case .artist(model: let artist):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
        return UITableViewCell()
      }
      
      let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: URL(string: artist.images?.first?.url ?? ""))
      
      cell.configure(with: viewModel)
      
      return cell

      
    case .album(model: let album):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
        return UITableViewCell()
      }
      
      let viewModel = SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.albumType, imageURL: URL(string: album.images.first?.url ?? ""))
      
      cell.configure(with: viewModel)
      
      return cell
      
    case .track(model: let track):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
        return UITableViewCell()
      }
      
      let viewModel = SearchResultSubtitleTableViewCellViewModel(title: track.name, subtitle: track.artists.first?.name ?? "-", imageURL: URL(string: track.album?.images.first?.url ?? ""))
      
      cell.configure(with: viewModel)
      
      return cell
      
    case .playlist(model: let playlist):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
        return UITableViewCell()
      }
      
      let viewModel = SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.displayName, imageURL: URL(string: playlist.images.first?.url ?? ""))
      
      cell.configure(with: viewModel)
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }
  
  /// called when the row is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let result = sections[indexPath.section].results[indexPath.row]
    
    delegate?.didTapResult(result)
  }

  
}
