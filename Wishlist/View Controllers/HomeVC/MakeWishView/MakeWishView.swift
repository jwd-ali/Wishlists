//
//  MakeWishView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 11.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

protocol AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?)
}

protocol ImagePickerDelegate {
    func showImagePickerControllerActionSheet()
}

protocol DismissViewDelegate {
    func dissmissViewComplete()
}

class MakeWishView: UIView, UITextFieldDelegate {

    let wishNameTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Was wünschst du dir?"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 19)
        v.textAlignment = .center
        v.placeholderColor(color: UIColor.white)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2.5)
        return v
    }()
    
    let linkTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Link hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.white)
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Preis hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.white)
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Notiz hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.white)
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "link")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "price")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "note")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishImageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishImageButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.setTitle("Bild hinzufügen", for: .normal)
        v.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 13)
        v.titleLabel?.numberOfLines = 0
        v.titleLabel?.textAlignment = .center
        v.addTarget(self, action: #selector(wishImageButtonTapped), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let grayView: UIView = {
        let v = UIView()
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "wishButtonBold"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(wishButtonTapped), for: .touchUpInside)
        v.contentVerticalAlignment = .fill
        v.contentHorizontalAlignment = .fill
        return v
    }()
    
    let wishButtonDisabled: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "wishButtonDisabled")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let closeButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "closeButtonWhite"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    var dataSourceArray = [Wishlist]()
    
    let dropDownButton: DropDownBtn = {
        let v = DropDownBtn()
        v.label.text = "Liste wählen"
        v.listImage.image = UIImage(named: "iconRoundedImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var keyboardHeight: CGFloat?
    
    var selectedWishlistIDX: Int?
    
    var addWishDelegate: AddWishDelegate?
    
    var imageButtonDelegate: ImagePickerDelegate?
    
    var dissmissViewDelegate: DismissViewDelegate?
    
    var amount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        self.wishNameTextField.becomeFirstResponder()
        UITextField.appearance().tintColor = .white
        
        // add target to wishNameTextfield to check if empty or not
        setupAddTargetIsNotEmptyTextFields()
        
        // allow dropDownButton to recieve selected wishlist
        dropDownButton.dropView.selectedWishlistDelegate = self
        
        // change priceKeyboard type to numbersPad
        priceTextField.keyboardType = UIKeyboardType.numberPad
        
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()

        addSubview(visualEffectView)
        addSubview(grayView)
        
        grayView.addSubview(wishButtonDisabled)
        grayView.addSubview(wishButton)
        grayView.addSubview(closeButton)
        
        grayView.addSubview(wishNameTextField)
        
        grayView.addSubview(wishImageView)
        grayView.addSubview(wishImageButton)
        
        grayView.addSubview(linkTextField)
        grayView.addSubview(priceTextField)
        grayView.addSubview(noteTextField)
        
        grayView.addSubview(linkImage)
        grayView.addSubview(priceImage)
        grayView.addSubview(noteImage)
        
        grayView.addSubview(dropDownButton)
    
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // constrain grayView
        grayView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        grayView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        grayView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        grayView.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
//        grayView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -140).isActive = true
        
        // constrain wishButton
        wishButtonDisabled.rightAnchor.constraint(equalTo: grayView.rightAnchor, constant: -20).isActive = true
        wishButtonDisabled.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -20).isActive = true
        wishButtonDisabled.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wishButtonDisabled.widthAnchor.constraint(equalToConstant: 80).isActive = true

        // constrain wishButton
        wishButton.rightAnchor.constraint(equalTo: grayView.rightAnchor, constant: -20).isActive = true
        wishButton.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -20).isActive = true
        wishButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // constrain closeButton
        closeButton.topAnchor.constraint(equalTo: grayView.topAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: grayView.leftAnchor).isActive = true
        
        // constrain dropDownButton
        dropDownButton.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -40).isActive = true
        dropDownButton.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 45).isActive = true
        dropDownButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dropDownButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // constrain wishNameTextfield
        wishNameTextField.centerXAnchor.constraint(equalTo: grayView.centerXAnchor).isActive = true
        wishNameTextField.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 45).isActive = true
        wishNameTextField.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -45).isActive = true
        wishNameTextField.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 50).isActive = true
        
        // constrain wishImage
        wishImageView.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 135).isActive = true
        wishImageView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 45).isActive = true
        wishImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wishImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // constrain wishImageButton
        wishImageButton.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 135).isActive = true
        wishImageButton.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 45).isActive = true
        wishImageButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wishImageButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // constrain linkImage
        linkImage.leadingAnchor.constraint(equalTo: wishImageView.leadingAnchor, constant: 80 + 30).isActive = true
        linkImage.topAnchor.constraint(equalTo: wishNameTextField.topAnchor, constant: 70).isActive = true
        linkImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // constrain linkTextfield
        linkTextField.leadingAnchor.constraint(equalTo: linkImage.leadingAnchor, constant: 30).isActive = true
        linkTextField.topAnchor.constraint(equalTo: linkImage.topAnchor).isActive = true
        linkTextField.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -30).isActive = true
        
        // constrain priceImage
        priceImage.leadingAnchor.constraint(equalTo: wishImageView.leadingAnchor, constant: 80 + 30).isActive = true
        priceImage.topAnchor.constraint(equalTo: linkImage.topAnchor, constant: 50).isActive = true
        priceImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // constrain priceTextfield
        priceTextField.leadingAnchor.constraint(equalTo: priceImage.leadingAnchor, constant: 30).isActive = true
        priceTextField.topAnchor.constraint(equalTo: priceImage.topAnchor).isActive = true
        priceTextField.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -30).isActive = true
        
        // constrain noteImage
        noteImage.leadingAnchor.constraint(equalTo: wishImageView.leadingAnchor, constant: 80 + 30).isActive = true
        noteImage.topAnchor.constraint(equalTo: priceImage.topAnchor, constant: 50).isActive = true
        noteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noteImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // constrain linkTextfield
        noteTextField.leadingAnchor.constraint(equalTo: priceImage.leadingAnchor, constant: 30).isActive = true
        noteTextField.topAnchor.constraint(equalTo: noteImage.topAnchor).isActive = true
        noteTextField.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -30).isActive = true
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func wishImageButtonTapped(){
        imageButtonDelegate?.showImagePickerControllerActionSheet()
        print("wishImageButtonTapped")
    }
    
    @objc func closeButtonTapped(){
        dissmissViewDelegate?.dissmissViewComplete()
        dismissView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check if added character is Int and add digit
        if let digit = Int(string){
            
            amount = amount * 10 + digit
            
            if amount > 100000000000 {
                priceTextField.text = ""
                amount = 0
         
            }else {
                priceTextField.text = updateAmount()
            }
        }
        // update textfield if character is deleted
        if string == "" {
            amount = amount/10
            priceTextField.text =  amount == 0 ? "" :updateAmount()
        }
        
        return false
    }
    
    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amt = Double(amount/100) + Double(amount%100)/100
        return formatter.string(from: NSNumber(value: amt))
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        wishButton.isHidden = true
        wishButtonDisabled.isHidden = false
        wishNameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .editingChanged)
    }
    
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        
        guard
            let wishName = wishNameTextField.text, !wishName.isEmpty
            else {
                // textfield is empty
                self.wishButtonDisabled.isHidden = false
                self.wishButton.isHidden = true
                return
        }
        // enable wishButton if all conditions are met
        wishButtonDisabled.isHidden = true
        wishButton.isHidden = false
    }
    
    @objc func wishButtonTapped(){
        insertWish()
        dismissView()
    }
    
    func insertWish(){
        
        var image = self.wishImageView.image
        var link = self.linkTextField.text!
        var price = self.priceTextField.text!
        var note = self.noteTextField.text!
        
        if image == nil {
            image = UIImage(named: "image")
        }
        if link == "" {
            link = "Link"
        }
        if price == "" {
            price = "Preis"
        }
        if note == "" {
            note = "Notiz"
        }
        
        addWishDelegate?.addWishComplete(wishName: self.wishNameTextField.text, selectedWishlistIDX: self.selectedWishlistIDX, wishImage: image, wishLink: link, wishPrice: price, wishNote: note)
        
//        saveWish()
    }
    
    func dismissView(){
        
        self.dropDownButton.dismissDropDown()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.grayView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.visualEffectView.alpha = 0
            self.grayView.alpha = 0
            self.wishButton.alpha = 0
            self.closeButton.alpha = 0
            self.dropDownButton.alpha = 0
            self.wishNameTextField.alpha = 0
            self.wishImageView.alpha = 0
            self.wishImageButton.alpha = 0
            self.linkTextField.alpha = 0
            self.priceTextField.alpha = 0
            self.noteTextField.alpha = 0
            self.linkImage.alpha = 0
            self.priceImage.alpha = 0
            self.noteImage.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    // get keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
}

extension MakeWishView: SelectedWishlistProtocol {
    func didSelectWishlist(idx: Int) {
        self.selectedWishlistIDX = idx
    }
}
