//
//  ProfileViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 24.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let signOutButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Ausloggen", for: .normal)
        v.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable swipe to pop viewcontroller
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self

        setupView()
    }
    
    func setupView() {
        
        view.addSubview(signOutButton)
        view.addSubview(backButton)
        
        signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func signoutButtonTapped() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.synchronize()
        
        let firstLaunchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLaunchVC")
        
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(firstLaunchVC, animated: false)
        
//        self.navigationController?.pushViewController(firstLaunchVC, animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
