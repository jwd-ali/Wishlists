//
//  MainCollectionView.swift
//  Wishlists
//
//  Created by Christian Konnerth on 02.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: CollectionView
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = theCollectionView.frame.width
        // based on iPhone SE 2 Width: 315 Height: 160 ScreenHeight: 667
        var h = w / 2.1
        if h > 160 {
            h = 160
        }
        
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return 1 more than our data array (the extra one will be the "add item" cell)
       return dataSourceArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       // if indexPath.item is less than data count, return a "Content" cell
       if indexPath.item < dataSourceArray.count {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
           // set cell label
           cell.cellLabel.text = dataSourceArray[indexPath.item].name
           // set cell image
           cell.wishlistImage.image = dataSourceArray[indexPath.item].image

           cell.priceLabel.textColor = dataSourceArray[indexPath.item].textColor
           cell.wishCounterLabel.textColor = dataSourceArray[indexPath.item].textColor
//           cell.wünscheLabel.textColor = dataSourceArray[indexPath.item].textColor

           // set background color
           cell.imageView.backgroundColor = dataSourceArray[indexPath.item].color
           cell.wishCounterView.backgroundColor = dataSourceArray[indexPath.item].color
           cell.priceView.backgroundColor = dataSourceArray[indexPath.item].color
           
           let heroID = "wishlistImageIDX\(indexPath.item)"
           cell.wishlistImage.heroID = heroID
           
           let addButtonHeroID = "addWishButtonID"
           self.addButton.heroID = addButtonHeroID
           
           cell.customWishlistTapCallback = {
               // track selected index
               self.currentWishListIDX = indexPath.item
                   
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistViewController
               
               vc.wishList = self.dataSourceArray[indexPath.item]
               // pass drop down options
               vc.dropOptions = self.dropOptions
               // pass current wishlist index
               vc.currentWishListIDX = indexPath.item
               // pass the data array
               vc.dataSourceArray = self.dataSourceArray
               // set Hero ID for transition
               vc.wishlistImage.heroID = heroID
               vc.addWishButton.heroID = addButtonHeroID
               // allow MainVC to recieve updated datasource array
               vc.dismissWishlistDelegate = self
            
               vc.selectedWishlistIDX = indexPath.item
            
               vc.theTableView.tableView.reloadData()
               self.present(vc, animated: true, completion: nil)
               
           }
           
           return cell
       }
       
       // past the end of the data count, so return an "Add Item" cell
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemCell.reuseID, for: indexPath) as! AddItemCell

       //MARK: addList-Cell-Tapped
       // set the closure
       cell.tapCallback = {
           
           self.createNewListView()
           // reset textfield
           self.createListView.wishlistNameTextField.text = ""
           // disable button
           self.createListView.disableButton()
           // start timer for imagePreview
           self.createListView.startImagePreviewAnimation()
           // set delegate
           self.createListView.createListDelegate = self
           
       }
       
       return cell
       
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       self.shouldAnimateCells = false
    }

    // animate displaying cells
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       if(self.shouldAnimateCells){
            // add animations here
           let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.1)
           let animator = Animator(animation: animation)
           animator.animate(cell: cell, at: indexPath, in: collectionView)
       }
    }
}
