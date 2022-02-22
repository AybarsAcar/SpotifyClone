//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 19/2/2022.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
  
  var albums = [Album]()
  
  private let noAlbumsView = ActionLabelView()
  
  private let tableView: UITableView = {
    let tv = UITableView(frame: .zero, style: .grouped)
    
    tv.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
    tv.isHidden = true
    
    return tv
  }()
  
  // observe the notification
  private var observer: NSObjectProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    setUpTableView()
    
    setUpNoAlbumsView()
    
    fetchData()
    
    observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in
      self?.fetchData()
    })
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    noAlbumsView.frame = CGRect(x: (view.width - 150) / 2, y: (view.height - 150) / 2, width: 150, height: 150)
    
    tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
  }
  
  private func setUpNoAlbumsView() {
    view.addSubview(noAlbumsView)
    noAlbumsView.delegate = self
    noAlbumsView.configure(with: ActionLabelViewModel(text: "You have not saved any albums yet.", actionTitle: "Browse"))
  }
  
  private func setUpTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func fetchData() {
    // remove the current albums
    albums.removeAll()
    
    APICaller.shared.getCurrentUserAlbums { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let albums):
          self?.albums = albums
          self?.updateUI()
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  private func updateUI() {
    if albums.isEmpty {
      // show label
      noAlbumsView.isHidden = false
      tableView.isHidden = true
    }
    else {
      // show table of playlists
      tableView.reloadData()
      tableView.isHidden = false
      noAlbumsView.isHidden = true
    }
  }
  
  @objc func didTapClose() {
    dismiss(animated: true, completion: nil)
  }
}


/// handle delegate actions
extension LibraryAlbumsViewController: ActionLabelViewDelegate {
  
  func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
    // switch the user back to the browse tab
    tabBarController?.selectedIndex = 0
  }
  
}


/// handle TableView Delegate & DataSource
extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
      return UITableViewCell()
    }
    
    let album = albums[indexPath.row]
    
    cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "-", imageURL: URL(string: album.images.first?.url ?? "")))
    
    return cell
  }

  /// update the height of the TableView cell
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  /// called when clicked
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // unhighlight it
    tableView.deselectRow(at: indexPath, animated: true)
    
    HapticsManager.shared.vibrateForSelection()
    
    let album = albums[indexPath.row]
    
    let vc = AlbumViewController(album: album)
    
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
    
  }
}
