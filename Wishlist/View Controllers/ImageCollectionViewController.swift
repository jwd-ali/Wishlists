//
//  ImageCollectionViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 05.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

protocol ClassBDelegate {
    func childVCDidComplete(with image: UIImage?)
}

class ImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var delegate: ClassBDelegate?

    
    let images: [UIImage] = [
        UIImage(named: "beerImage")!,
        UIImage(named: "christmasImage")!,
        UIImage(named: "goalImage")!,
        UIImage(named: "travelImage")!,
        UIImage(named: "rollerImage")!,
        UIImage(named: "giftImage")!,
        UIImage(named: "shirtImage")!,
        UIImage(named: "dressImage")!,
        
    ]
    
    let columnLayout = FlowLayout(
        itemSize: CGSize(width: 150, height: 150),
        minimumInteritemSpacing: 30,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        
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
       delegate?.childVCDidComplete(with: tappedImage)
       navigationController?.popViewController(animated: true)
    }
    
    var showPopUpView = true
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var vc = segue.destination as! ExampleViewController
//        vc.pickedImage = self.tappedImage
//        vc.ShowPopUpView = self.showPopUpView
//
//    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! ExampleViewController
                self.present(HomeViewController, animated: false, completion: nil)
    }
}


