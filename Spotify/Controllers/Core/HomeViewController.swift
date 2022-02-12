//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    title = "Home"
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
  }
  
  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

