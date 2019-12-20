//
//  ImageCollectionViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 05.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

protocol ClassBDelegate { 
    func childVCDidComplete(with image: UIImage?, index: Int?)
}

class ImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var delegate: ClassBDelegate?

    let images: [UIImage] = [
        UIImage(named: "avocadoImage")!,
        UIImage(named: "beerImage")!,
        UIImage(named: "bikeImage")!,
        UIImage(named: "christmasImage")!,
        UIImage(named: "dressImage")!,
        UIImage(named: "giftImage")!,
        UIImage(named: "goalImage")!,
        UIImage(named: "rollerImage")!,
        UIImage(named: "shirtImage")!,
        UIImage(named: "shoeImage")!,
        UIImage(named: "travelImage")!,
        
    ]
    
    
    
    let columnLayout = CenterAlignedCollectionViewFlowLayout(
//        itemSize: CGSize(width: 150, height: 150),
//        minimumInteritemSpacing: 25,
//        minimumLineSpacing: 10,
//        sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    )
    
    var colViewWidth: CGFloat = 0.0
        
    override func viewDidLoad() {
        
        self.imageCollectionView.collectionViewLayout = columnLayout

        super.viewDidLoad()
//        if imageCollectionView.frame.width != colViewWidth {
//            let w = imageCollectionView.frame.width / 2 - 30
//            columnLayout.itemSize = CGSize(width: w, height: w + 50)
//            colViewWidth = imageCollectionView.frame.width
//            imageCollectionView.collectionViewLayout = columnLayout
//        }
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        cell.layer.cornerRadius = 2
        return cell
    }
    
    var tappedImage = UIImage()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedImage = images[indexPath.row]
        delegate?.childVCDidComplete(with: tappedImage, index: indexPath.row)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


