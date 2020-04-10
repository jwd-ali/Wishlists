//
//  ImageCollectionViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 05.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

protocol ListImagePickDelegate { 
    func listImagePicked(with image: UIImage?, index: Int?)
}

class ImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    let theCollectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.contentInsetAdjustmentBehavior = .always
        return v
    }()
    
    
    let closeButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "closeButton"), for: .normal)
        v.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let theLabel: UILabel = {
        let v = UILabel()
        v.text = "Bild wählen"
        v.font = UIFont(name: "AvenirNext-Bold", size: 23)
        v.textAlignment = .center
        v.textColor = .darkGray
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var delegate: ListImagePickDelegate?
    
    let columnLayout = CenterAlignedCollectionViewFlowLayout()
        
    override func viewDidLoad() {

        super.viewDidLoad()
        setupViews()
        
        theCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        // set collection view dataSource
        theCollectionView.dataSource = self

        theCollectionView.delegate = self

        // use custom flow layout
        theCollectionView.collectionViewLayout = columnLayout
    }
    
    func setupViews(){
        view.addSubview(closeButton)
        view.addSubview(theLabel)
        view.addSubview(theCollectionView)
        
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        theLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        theLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        
        theCollectionView.topAnchor.constraint(equalTo: theLabel.bottomAnchor, constant: 30).isActive = true
        theCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        theCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        theCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.Wishlist.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.cellImage.image = Constants.Wishlist.images[indexPath.item]
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 2
        return cell
    }
    
    var tappedImage = UIImage()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedImage = Constants.Wishlist.images[indexPath.row]
        delegate?.listImagePicked(with: tappedImage, index: indexPath.row)
        
        self.dismiss(animated: true)
    }
    
    @objc func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


