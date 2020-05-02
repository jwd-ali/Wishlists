//
//  ListSettingsTableViewController.swift
//  Wishlists
//
//  Created by Christian Konnerth on 25.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

protocol DeleteListDelegate {
    func deleteListTapped(dataArray: [Wishlist], dropArray: [DropDownOption])
}

extension WishlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menueOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenueOptionCell.reuseID, for: indexPath) as! MenueOptionCell
        
        cell.theTitle.text = menueOptions[indexPath.row].title
        cell.theImage.image = menueOptions[indexPath.row].image

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissMenueTableView()
        
        self.menueTableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {

        case 0: // bearbeiten
            editTapped()
        
        case 1: // sichtbar machen
            print("sichtbar")
        
        case 2: // löschen
            deleteTapped()
            
        case 3: // teilen
            print("teilen")
                
        default:
            break
        }
    }
    //MARK: deleteTapped
    func deleteTapped(){
        
        let alertcontroller = UIAlertController(title: "Wishlist löschen", message: "Sicher, dass du diese Wishlist löschen möchtest?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Löschen", style: .default) { (alert) in

            DataHandler.deleteWishlist(self.wishList.index)
            
            // change heroID so wishlist image doesnt animate
            self.wishlistImage.heroID = "delete"
            
            self.dismiss(animated: true, completion: nil)
            
            //  update datasource array in MainVC
            self.dismissWishlistDelegate?.dismissWishlistVC(dataArray: self.dataSourceArray, dropDownArray: self.dropOptions, shouldDeleteWithAnimation: true, indexToDelete: self.currentWishListIDX)
            
            
            self.deleteListDelegate?.deleteListTapped(dataArray: self.dataSourceArray, dropArray: self.dropOptions)
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .default) { (alert) in
            print("abbrechen")
        }

        
        alertcontroller.addAction(cancelAction)
        alertcontroller.addAction(deleteAction)
        
        self.present(alertcontroller, animated: true)
    }
    //MARK: edidTapped
    func editTapped(){
        view.removeGestureRecognizer(panGR)
        self.createNewListView()
        self.setUpNewListView()
        
    }
    //MARK: setUpNewListView
    func setUpNewListView(){
        self.createListView.wishList = self.wishList
        self.createListView.oldListName = self.wishList.name
        self.createListView.wishlistNameTextField.text = wishList.name
        self.createListView.imagePreview.image = wishList.image
        self.createListView.currentImage = wishList.image
        self.createListView.currentImageIndex = Constants.Wishlist.getCurrentImageIndex(image: wishList.image)
        self.createListView.wishlistNameTextField.becomeFirstResponder()
        self.createListView.changeListDelegate = self
        self.createListView.closeViewDelegate = self
    }
    
    
    // MARK: CreateNewListView
    func createNewListView(){
        
        createListView.isHidden = false
        createListView.wishlistNameTextField.becomeFirstResponder()
         
         for view in self.createListView.subviews as [UIView] {
             view.alpha = 0
             view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
         }
         
         UIView.animate(withDuration: 0.3) {
             
             for view in self.createListView.subviews as [UIView] {
                 view.alpha = 1
                 view.transform = CGAffineTransform.identity
             }
        }
        
    }
}

//MARK: SaveListChangesDelegate
extension WishlistViewController: ChangeListDelegate, CloseNewListViewDelegate {
    
    func closeNewListViewTapped() {
        view.addGestureRecognizer(panGR)
    }
    
    func saveChangesTappedDelegate(listImage: UIImage, listImageIndex: Int, listName: String) {
        view.addGestureRecognizer(panGR)
        // update current Wishlist
        var textColor = UIColor.white
        
        if Constants.Wishlist.darkTextColorIndexes.contains(listImageIndex) {
            textColor = UIColor.darkGray
        }
        self.wishList = Wishlist(name: listName, image: listImage, wishes: [Wish](), color: Constants.Wishlist.customColors[listImageIndex], textColor: textColor, index: self.wishList.index)
        
        self.dataSourceArray[self.currentWishListIDX] = self.wishList
        
        
        self.wishlistImage.image = listImage
        self.wishlistLabel.text = listName
       
        // update drop down options
        self.dropOptions[self.currentWishListIDX].name = listName
        self.dropOptions[self.currentWishListIDX].image = listImage
        self.wishView.dropDownButton.dropView.tableView.reloadData()

    }
}

