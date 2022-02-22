//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  private let signInButton: UIButton = {
    let button = UIButton()
    
    button.backgroundColor = .white
    button.setTitle("Sign In with Spotify", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    return button
  }()
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "albums_background")
    return imageView
  }()
  
  private let overlayView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.9
    return view
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "logo")
    return imageView
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .white
    label.font = .systemFont(ofSize: 32, weight: .semibold)
    label.text = "Listen to Millions\nof Songs on\nthe go."
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Spotify"
    view.backgroundColor = .black
    
    view.addSubview(backgroundImageView)
    view.addSubview(overlayView)
    
    view.addSubview(signInButton)
    signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    
    view.addSubview(label)
    view.addSubview(logoImageView)
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    backgroundImageView.frame = view.bounds
    overlayView.frame = view.bounds
    
    signInButton.frame = CGRect(
      x: 20,
      y: view.height - 50 - view.safeAreaInsets.bottom,
      width: view.width - 40,
      height: 50
    )
    
    logoImageView.frame = CGRect(x: (view.width - 120) / 2, y: (view.height - 350) / 2, width: 120, height: 120)
    
    label.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: view.width - 60, height: 150)
  }
  
  
  @objc func didTapSignIn() {
    let vc = AuthViewController()
    
    vc.completionHandler = { [weak self] success in
      DispatchQueue.main.async {
        self?.handleSignIn(success: success)
      }
    }
    
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  /// handles the user login or returns the error
  /// if sign in is successful navigates the user to the home page
  private func handleSignIn(success: Bool) {
    guard success else {
      let alert = UIAlertController(title: "Oopps..", message: "Something went wrong when signing in.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
      present(alert, animated: true)
      return
    }
    
    let mainAppTabBarVC = TabBarViewController()
    
    mainAppTabBarVC.modalPresentationStyle = .fullScreen
    
    // present teh full screen modal
    present(mainAppTabBarVC, animated: true)
  }
}
