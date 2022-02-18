//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 19/2/2022.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
  
  var playlists = [Playlist]()
  
  private let noPlaylistsView = ActionLabelView()
  
  private let tableView: UITableView = {
    let tv = UITableView(frame: .zero, style: .grouped)
    
    tv.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
    tv.isHidden = true
    
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    setUpTableView()
    
    setUpNoPlaylistView()
    
    fetchData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
    noPlaylistsView.center = view.center
    
    tableView.frame = view.bounds
  }
  
  func showCreatePlaylistAlert() {
    let alert = UIAlertController(title: "New Playlists", message: "Enter playlist name", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "Playlist..."
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
      
      // get the text in the textField out
      guard let field = alert.textFields?.first,
            let text = field.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty
      else {
        return
      }
      
      APICaller.shared.createPlaylist(with: text) { success in
        
        if success {
          // Refresh lists of playlist
        }
        else {
          print("Failed to create playlists")
        }
      }
    }))
    
    present(alert, animated: true)
  }
  
  private func setUpNoPlaylistView() {
    view.addSubview(noPlaylistsView)
    noPlaylistsView.delegate = self
    noPlaylistsView.configure(with: ActionLabelViewModel(text: "You don't have any playlists yet", actionTitle: "Create"))
  }
  
  private func setUpTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func fetchData() {
    APICaller.shared.getCurrentUserPlaylists { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let playlists):
          self?.playlists = playlists
          self?.updateUI()
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  private func updateUI() {
    if playlists.isEmpty {
      // show label
      noPlaylistsView.isHidden = false
      tableView.isHidden = true
    }
    else {
      // show table of playlists
      tableView.reloadData()
      tableView.isHidden = false
      noPlaylistsView.isHidden = true
    }
  }
  
}


/// handle delegate actions
extension LibraryPlaylistViewController: ActionLabelViewDelegate {
  
  func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
    
   showCreatePlaylistAlert()
  }
  
}


/// handle TableView Delegate & DataSource
extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return playlists.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
      return UITableViewCell()
    }
    
    let playlist = playlists[indexPath.row]
    
    cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.displayName, imageURL: URL(string: playlist.images.first?.url ?? "")))
    
    return cell
  }

  /// update the height of the TableView cell
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}
