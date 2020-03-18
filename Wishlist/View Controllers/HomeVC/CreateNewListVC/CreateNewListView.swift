//
//  CreateNewListView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 17.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class CreateNewListView: UIView {
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let closeButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "closeButton"), for: .normal)
        v.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let imagePreview: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "beerImage")
        return v
    }()

    let editButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "editButton"), for: .normal)
        v.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let wishlistNameTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Wie soll deine Wishlist heißen?"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.textAlignment = .center
        v.placeholderColor(color: UIColor.white)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2.5)
        return v
    }()
    
    let createButton: CustomButton = {
        let v = CustomButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Liste erstellen", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.titleLabel?.textColor = .white
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(createListTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
    super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setupViews
    func setupViews(){
        
        addSubview(visualEffectView)
        addSubview(closeButton)
        addSubview(imagePreview)
        addSubview(editButton)
        addSubview(wishlistNameTextField)
        addSubview(createButton)
        
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        imagePreview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        imagePreview.heightAnchor.constraint(equalToConstant: 160).isActive = true
        imagePreview.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imagePreview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        editButton.topAnchor.constraint(equalTo: imagePreview.topAnchor, constant: 120).isActive = true
        editButton.leadingAnchor.constraint(equalTo: imagePreview.leadingAnchor, constant: 120).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        wishlistNameTextField.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 50).isActive = true
        wishlistNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        wishlistNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
//        wishlistNameTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        createButton.topAnchor.constraint(equalTo: wishlistNameTextField.bottomAnchor, constant: 20).isActive = true
        createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    //MARK: closeButtonTapped
    @objc func closeButtonTapped(){
        dismissView()
    }
    
    func dismissView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imagePreview.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.visualEffectView.alpha = 0
            self.imagePreview.alpha = 0
            self.editButton.alpha = 0
            self.closeButton.alpha = 0
            self.wishlistNameTextField.alpha = 0
            self.createButton.alpha = 0

        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: editButtonTapped
    @objc func editButtonTapped(){
        print("hi")
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc: ImageCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ImageCollectionVC") as! ImageCollectionViewController
            let currentController = self.getCurrentViewController()
            currentController?.present(vc, animated: false, completion: nil)
        
    }
    
    // helper function for navigation to ImageCollectionView
     func getCurrentViewController() -> UIViewController? {

        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil

    }
    //MARK: createListButtonTapped
    @objc func createListTapped(){
        
    }
    
}
