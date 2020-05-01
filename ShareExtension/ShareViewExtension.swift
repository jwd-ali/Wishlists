//
//  ShareViewExtension.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 01.05.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

extension CustomShareViewController {
    
    
    
    // MARK: AddWishButton
    @objc func addWishButtonTapped(){
        
        self.view.bringSubviewToFront(self.wishView)
        
//        wishView.dropDownButton.dropView.dropOptions = self.dropOptions
//        wishView.dropDownButton.dropView.tableView.reloadData()
//
//        // set dropDownButton image and label to first wishlists image and label
//        wishView.dropDownButton.listImage.image = self.dataSourceArray[self.currentWishListIDX].image
//        wishView.dropDownButton.label.text = self.dataSourceArray[self.currentWishListIDX].name

        
        wishView.wishNameTextField.becomeFirstResponder()
        wishView.disableButton()
        wishView.wishNameTextField.text = ""
        wishView.priceTextField.text = ""
        wishView.linkTextField.text = ""
        wishView.noteTextField.text = ""
        wishView.wishImageView.image = nil
        wishView.amount = 0
        
        onImageButtonTappedClosure()
        onPriceButtonTappedClosure()
        onLinkButtonTappedClosure()
        onNoteButtonTappedClosure()
        
        transparentView.gestureRecognizers?.forEach {
            self.transparentView.removeGestureRecognizer($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissWishView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.6
        }, completion: nil)

    }
    
    //MARK: onImageButtonTappedClosure
    func onImageButtonTappedClosure(){
        self.wishView.onImageButtonTapped = { [unowned self] height, isHidden in

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.wishConstraint.constant += height
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    //MARK: onPriceButtonClosure
    func onPriceButtonTappedClosure(){
        self.wishView.onPriceButtonTapped = { [unowned self] height, isHidden in
            
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.priceTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    //MARK: onLinkButtonTappedClosure
    func onLinkButtonTappedClosure(){
       self.wishView.onLinkButtonTapped = { [unowned self] height, isHidden in
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.linkTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    //MARK: onNoteButtonTappedClosure
    func onNoteButtonTappedClosure(){
       self.wishView.onNoteButtonTapped = { [unowned self] height, isHidden in
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.noteTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    //MARK: dismissWishView
    @objc func dismissWishView() {
        
        wishView.dropDownButton.dismissDropDown()
        
        self.view.layoutIfNeeded()
        
        self.wishView.endEditing(true)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.wishConstraint.constant = 0
            self.view.layoutIfNeeded()

        }) { (done) in
            self.wishView.priceView.isHidden = true
            self.wishView.linkView.isHidden = true
            self.wishView.noteView.isHidden = true
            self.wishView.imageContainerView.isHidden = true
        }
        
    }

}

//MARK: AddWishDelegate
extension CustomShareViewController: AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?) {
        
//        self.dataSourceArray[selectedWishlistIDX!].wishData.append(Wish(withWishName: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checked: false))
        
        self.doneAction()
        dismissWishView()
    }
}

