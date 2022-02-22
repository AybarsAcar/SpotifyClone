//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    return tableView
  }()
  
  private var sections = [Section]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureModels()
    
    title = "Settings"
    view.backgroundColor = .systemBackground
    
    // add the table view and assign the data source
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  private func configureModels() {
    
    sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: { [weak self] in
      DispatchQueue.main.async {
        self?.viewProfile()
      }
    })]))
    
    sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: { [weak self] in
      DispatchQueue.main.async {
        self?.signOutTapped()
      }
    })]))
  }
  
  private func signOutTapped() {
    
    let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
      self?.signOut()
    }))
    
    present(alert, animated: true)
  }
  
  private func signOut() {
    
    AuthManager.shared.signOut { [weak self] success in
      if success {
        // push them into the welcome screen
        DispatchQueue.main.async {
          
          let navVC = UINavigationController(rootViewController: WelcomeViewController())
          
          // set the title to large
          navVC.navigationBar.prefersLargeTitles = true
          navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
          navVC.modalPresentationStyle = .fullScreen
          self?.present(navVC, animated: true, completion: {
            // remove everything off the navigation stack
            self?.navigationController?.popToRootViewController(animated: false)
          })
        }
      }
    }
  }
  
  private func viewProfile() {
    let vc = ProfileViewController()
    
    vc.title = "Profile"
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  // MARK: - TableView
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = sections[indexPath.section].options[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = model.title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Cell handler for cll
    let model = sections[indexPath.section].options[indexPath.row]

    model.handler()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let model = sections[section]
    return model.title
  }
}
