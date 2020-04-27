//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 22.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import Social
import SwiftSoup


class CustomShareViewController: UIViewController {
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named:"dismissButton"), for: .normal)
        v.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return v
    }()
    
    let actionButton: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Action", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 23)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(actionButton)
        actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    @objc func actionButtonTapped(){
        print("yeet")
        
//        print(extensionContext?.inputItems as Any)
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first,
            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if (url as? URL) != nil {
                    print(self.getHTMLfromURL(url: url as? URL))
                }
                
            }
        }
        
    }
    
    
    func getHTMLfromURL(url: URL?) -> String{
        let myURLString = url
        guard let myURL = myURLString else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return ""
        }

        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
        }
        
        return ""
    }
}
