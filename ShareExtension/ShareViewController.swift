//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 22.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import Social

class CustomShareViewController: UIViewController {
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        
        setupViews()
//        setupNavBar()
    }
    
    private func setupViews(){
        view.addSubview(visualEffectView)
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "Wishlists"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
