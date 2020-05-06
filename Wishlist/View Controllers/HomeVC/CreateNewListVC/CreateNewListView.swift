//
//  CreateNewListView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 17.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

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
        v.placeholder = "Wunschliste"
        v.textColor = .darkCustom
        v.tintColor = .lightGray
        v.font = UIFont(name: "AvenirNext-Bold", size: 19)
        v.textAlignment = .center
        v.placeholderColor(color: UIColor.lightGray)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2)
        v.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        v.keyboardAppearance = UIKeyboardAppearance.default
        return v
    }()
    
    let createButton: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Liste erstellen", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = UIColor.blueCustom
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(createListTapped), for: .touchUpInside)
        return v
    }()
    
    var createListDelegate: CreateListDelegate?
    
    var changeListDelegate: ChangeListDelegate?
    
    var closeViewDelegate: CloseNewListViewDelegate?
    
    var currentImage =  Constants.Wishlist.images[0]
    var currentImageIndex = 0
    
//    var currentWishlistIndex: Int?
//    var ok: Int?
    // only important if changing listname
    var oldListName: String?
    
    // timer for imagePreview
    var timer: Timer?
    
    var wishList: Wishlist?
    
    var bottomConstraint: NSLayoutConstraint!
    
    var wishlistMode: Constants.WishlistMode?
    
    //MARK: init
    init(wishlistMode: Constants.WishlistMode) {
        self.wishlistMode = wishlistMode
        super.init(frame: CGRect.zero)
        
        setupViews()
        
        wishlistNameTextField.delegate = self
        
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
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth  = UIScreen.main.bounds.size.width
        
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
        
        createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.bottomConstraint = createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(screenHeight/3))
        bottomConstraint.isActive = true
        
        wishlistNameTextField.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20).isActive = true
        wishlistNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        wishlistNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
        imagePreview.bottomAnchor.constraint(equalTo: wishlistNameTextField.topAnchor, constant: -55).isActive = true
        imagePreview.heightAnchor.constraint(equalToConstant: screenWidth/2.3).isActive = true
        imagePreview.widthAnchor.constraint(equalToConstant: screenWidth/2.3).isActive = true
        imagePreview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        editButton.topAnchor.constraint(equalTo: imagePreview.topAnchor, constant: screenWidth/2.3 - 45).isActive = true
        editButton.leadingAnchor.constraint(equalTo: imagePreview.leadingAnchor, constant: screenWidth/2.3 - 45).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 90).isActive = true

    }
    
    //MARK: closeButtonTapped
    @objc func closeButtonTapped(){
        closeViewDelegate?.closeNewListViewTapped()
        timer?.invalidate()
        dismissView()
    }
    
    func dismissView(){
        
        wishlistNameTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            for view in self.subviews as [UIView] {
                view.alpha = 0
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }

        }) { (_) in
            self.isHidden = true
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
            currentController?.present(vc, animated: true, completion: nil)
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 13
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

        createListDelegate?.createListTappedDelegate(listImage: currentImage, listImageIndex: currentImageIndex, listName: wishlistNameTextField.text!)
        
        changeListDelegate?.saveChangesTappedDelegate(listImage: currentImage, listImageIndex: currentImageIndex, listName: wishlistNameTextField.text!)
        
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
