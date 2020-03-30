//
//  CreateNewListView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 17.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol CreateListDelegate {
    func createListTappedDelegate(listImage: UIImage, listImageIndex: Int, listName: String)
}

protocol ChangeListDelegate {
    func saveChangesTappedDelegate(listImage: UIImage, listImageIndex: Int, listName: String)
}

protocol CloseNewListViewDelegate {
    func closeNewListViewTapped()
}

class CreateNewListView: UIView, UITextFieldDelegate {
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let closeButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "closeButtonWhite"), for: .normal)
        v.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let imagePreview: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = Constants.Wishlist.images[0]
        return v
    }()

    let editButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "editButtonWhite"), for: .normal)
        v.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let wishlistNameTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Wie soll deine Wishlist heißen?"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Medium", size: 19)
        v.textAlignment = .center
        v.placeholderColor(color: UIColor.white)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2)
        v.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        v.autocorrectionType = .no
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
    
    var createListDelegate: CreateListDelegate?
    
    var changeListDelegate: ChangeListDelegate?
    
    var closeViewDelegate: CloseNewListViewDelegate?
    
    var currentImage: UIImage?
    var currentImageIndex = 0
    
//    var currentWishlistIndex: Int?
//    var ok: Int?
    // only important if changing listname
    var oldListName: String?
    
    // timer for imagePreview
    var timer: Timer?
    
    var wishList: Wishlist?
    
    var wishlistMode: Constants.WishlistMode?

    init(wishlistMode: Constants.WishlistMode) {
        self.wishlistMode = wishlistMode
        super.init(frame: CGRect.zero)
        
        setupViews()
        
        wishlistNameTextField.delegate = self
        
//        currentImage = Constants.Wishlist.images[self.currentImageIndex]
        
        setButtonTitleWithWishlistMode()
        
        saveOldListNameIfNeeded()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func saveOldListNameIfNeeded(){
        if self.wishlistMode == .isChanging {
            self.oldListName = wishlistNameTextField.text!
        }
    }
    
    func setButtonTitleWithWishlistMode(){
        switch self.wishlistMode {
        case .isChanging:
            self.createButton.setTitle("Änderung speichern", for: .normal)
        case .isCreating:
            self.createButton.setTitle("Liste erstellen", for: .normal)
        default:
            break
        }
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
        
        editButton.topAnchor.constraint(equalTo: imagePreview.topAnchor, constant: 110).isActive = true
        editButton.leadingAnchor.constraint(equalTo: imagePreview.leadingAnchor, constant: 110).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        wishlistNameTextField.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 65).isActive = true
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
        closeViewDelegate?.closeNewListViewTapped()
        timer?.invalidate()
        wishlistNameTextField.resignFirstResponder()
        dismissView()
        
    }
    
    func dismissView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imagePreview.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.wishlistNameTextField.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.createButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.closeButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.editButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
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
    
    //MARK: ImagePreviewAnimation
    func startImagePreviewAnimation(){
        timer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        currentImage = Constants.Wishlist.images[self.currentImageIndex]
        currentImageIndex = (currentImageIndex + 1) % Constants.Wishlist.images.count
        UIView.transition(with: self.imagePreview, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imagePreview.image = Constants.Wishlist.images[self.currentImageIndex]
            self.currentImage = self.imagePreview.image!
        })
    }
    
    //MARK: editButtonTapped
    @objc func editButtonTapped(){
 
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc: ImageCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ImageCollectionVC") as! ImageCollectionViewController
            // important: set delegate to self to recieve data from ImagePickVC
            vc.delegate = self
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
    
    //MARK: Enable Button Methods
    @objc func textFieldDidChange(){
        if self.wishlistNameTextField.text == "" {
            disableButton()
        } else {
            enableButton()
        }
    }
    
    func disableButton(){
        self.createButton.isEnabled = false
        self.createButton.alpha = 0.7
    }
    
    func enableButton(){
        self.createButton.isEnabled = true
        self.createButton.alpha = 1
    }
    
    //MARK: createListButtonTapped
    @objc func createListTapped(){
        
        var textColor = Constants.Wishlist.textColor.white
        if Constants.Wishlist.darkTextColorIndexes.contains(currentImageIndex){
            textColor = Constants.Wishlist.textColor.darkGray
        }
        
        
        switch self.wishlistMode {
        case .isChanging:
            DataHandler.updateWishlist(wishListName: wishlistNameTextField.text!, oldListName: self.oldListName!, imageArrayIDX: currentImageIndex, wishListIDX: self.wishList!.index, textColor: textColor)
        case .isCreating:
            DataHandler.saveWishlist(wishListName: wishlistNameTextField.text!, imageArrayIDX: currentImageIndex, textColor: textColor)
        default:
            break
        }
        
        timer?.invalidate()
        
        dismissView()
        
        createListDelegate?.createListTappedDelegate(listImage: currentImage!, listImageIndex: currentImageIndex, listName: wishlistNameTextField.text!)
        
        changeListDelegate?.saveChangesTappedDelegate(listImage: currentImage!, listImageIndex: currentImageIndex, listName: wishlistNameTextField.text!)
        
    }
    
}

//MARK: Delegate Extension
extension CreateNewListView: ListImagePickDelegate {
    func listImagePicked( with image: UIImage?, index: Int?) {
        self.currentImageIndex = index!
        self.currentImage = image!
        self.imagePreview.image = image!
        self.timer?.invalidate()
    }
}
