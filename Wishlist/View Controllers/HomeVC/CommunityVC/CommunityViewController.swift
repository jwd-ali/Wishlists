//
//  CommunityViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 01.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import Lottie

class CommunityViewController: UIViewController {
    
    let backGroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "backButton"), for: .normal)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        v.setImageTintColor(.darkGray)
        return v
    }()
    
    let showAnimation: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("show animation", for: .normal)
        v.addTarget(self, action: #selector(showAnimationTapped), for: .touchUpInside)
        v.setImageTintColor(.darkGray)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        view.addSubview(backGroundImage)
        view.addSubview(backButton)
        view.addSubview(showAnimation)
        
        backGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20).isActive = true
        backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        
        showAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300).isActive = true
        showAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func showAnimationTapped(){
        
        let logoAnimation = AnimationView(name: "StrokeAnimation")
        logoAnimation.contentMode = .scaleAspectFit
        logoAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoAnimation)
        
        logoAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoAnimation.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoAnimation.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        logoAnimation.play()
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



