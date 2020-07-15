//
//  WishWishView.swift
//  Wishlists
//
//  Created by Christian Konnerth on 02.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerDelegate {
    func showImagePickerControllerActionSheet()
}

protocol AddWishDelegate {
    func addWishComplete(wishName: String, selectedWishlistIDX: Int, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?)
}

class WishView: UIView, UITextFieldDelegate {
    
    //MARK: StackView
    let theStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    //MARK: ItemView
    let itemView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let itemScrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "photo"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let priceButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "eurosign.circle"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let linkButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "link"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let noteButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "pencil"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(noteButtonTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: ImageView
    
    var onImageButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    let imageContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let wishImageViewHeight: CGFloat = 60
    
    let wishImageView: ShadowRoundedImageView = {
        let v = ShadowRoundedImageView()
        v.backgroundColor = .clear
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .cyan
        return v
    }()
    
    var wishImageViewWidthConstraint: NSLayoutConstraint!
    
    
    let deleteImageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        v.tintColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(deleteImageButtonTapped), for: .touchUpInside)
        return v
    }()
    
    
    //MARK: WishView
    let wishView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishViewHeight = 70
    
    let wishNameTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Was wünschst du dir?"
//        v.placeholderColor(color: .lightGray)
        v.textColor = .darkCustom
        v.font = UIFont(name: "AvenirNext-Bold", size: 19)
        v.tintColor = .darkCustom
        v.textAlignment = .left
        v.keyboardAppearance = .default
        v.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "arrowUpCircle"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(wishButtonTapped), for: .touchUpInside)
        v.contentVerticalAlignment = .fill
        v.contentHorizontalAlignment = .fill
        return v
    }()
    
    //MARK: PriceView
    
    var onPriceButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    let priceView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.textColor = .darkCustom
        v.text = "Preis:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Preis hinzufügen"
        v.textColor = .darkCustom
        v.tintColor = .darkCustom
//        v.placeholderColor(color: UIColor.lightGray)
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .right
        v.keyboardType = .numberPad
        v.keyboardAppearance = .default
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: LinkView
    
    var onLinkButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    let linkView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkLabel: UILabel = {
        let v = UILabel()
        v.textColor = .darkCustom
        v.text = "Link:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Link hinzufügen"
        v.textColor = .darkCustom
        v.tintColor = .darkCustom
//        v.placeholderColor(color: UIColor.lightGray)
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: NoteView
    
    var onNoteButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    let noteView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteLabel: UILabel = {
        let v = UILabel()
        v.textColor = .darkCustom
        v.text = "Notiz:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Notiz hinzufügen"
        v.textColor = .darkCustom
        v.tintColor = .darkCustom
//        v.placeholderColor(color: UIColor.lightGray)
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
         
    let dropDownButton: DropDownBtn = {
        let v = DropDownBtn()
        v.label.text = "Liste wählen"
        v.listImage.image = UIImage(named: "iconRoundedImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var dataSourceArray = [Wishlist]()

    var imageButtonDelegate: ImagePickerDelegate?
    
    var addWishDelegate: AddWishDelegate?
    
    var selectedWishlistIDX: Int?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupViews()
    
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()
        
        dropDownButton.dropView.selectedWishlistDelegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: set
    func set(image: UIImage) {
        let ratio = image.size.width / image.size.height
        wishImageView.image = image
        wishImageViewWidthConstraint.constant = ratio * wishImageViewHeight
    }
    
    //MARK: setupViews
    func setupViews(){
        
        addSubview(theStackView)
        theStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        theStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        theStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        theStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        theStackView.addArrangedSubview(self.wishView)
        wishView.addSubview(wishNameTextField)
        wishView.addSubview(wishButton)
        
        wishView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        wishButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        wishButton.trailingAnchor.constraint(equalTo: wishView.trailingAnchor, constant: -20).isActive = true
        wishButton.centerYAnchor.constraint(equalTo: wishView.centerYAnchor, constant: 10).isActive = true
        
        wishNameTextField.leadingAnchor.constraint(equalTo: wishView.leadingAnchor, constant: 20).isActive = true
        wishNameTextField.centerYAnchor.constraint(equalTo: wishView.centerYAnchor, constant: 10).isActive = true
        wishNameTextField.trailingAnchor.constraint(equalTo: wishButton.leadingAnchor, constant: -20).isActive = true
        
        //MARK: image
        theStackView.addArrangedSubview(self.imageContainerView)
        imageContainerView.addSubview(wishImageView)
        imageContainerView.addSubview(deleteImageButton)
        
        imageContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageContainerView.isHidden = true
        
        wishImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 20).isActive = true
        wishImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 5).isActive = true
        wishImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -5).isActive = true
        
        wishImageViewWidthConstraint = wishImageView.widthAnchor.constraint(equalToConstant: wishImageViewHeight)
        wishImageViewWidthConstraint.isActive = true
        wishImageView.heightAnchor.constraint(equalToConstant: wishImageViewHeight).isActive = true
        
        wishImageView.isHidden = true
        
        deleteImageButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteImageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteImageButton.topAnchor.constraint(equalTo: wishImageView.topAnchor, constant: -10).isActive = true
        deleteImageButton.trailingAnchor.constraint(equalTo: wishImageView.trailingAnchor, constant: 10).isActive = true
        
        deleteImageButton.isHidden = true
        
        //MARK: price
        theStackView.addArrangedSubview(self.priceView)
        priceView.addSubview(priceLabel)
        priceView.addSubview(priceTextField)
        
        priceView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        priceView.isHidden = true
        
        priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 20).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        priceTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10).isActive = true
        priceTextField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -20).isActive = true
        priceTextField.centerYAnchor.constraint(equalTo: priceView.centerYAnchor, constant: 1).isActive = true
        
        //MARK: link
        theStackView.addArrangedSubview(self.linkView)
        linkView.addSubview(linkLabel)
        linkView.addSubview(linkTextField)
        
        linkView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        linkView.isHidden = true
        
        linkLabel.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: 20).isActive = true
        linkLabel.centerYAnchor.constraint(equalTo: linkView.centerYAnchor).isActive = true
        linkLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        linkTextField.leadingAnchor.constraint(equalTo: linkLabel.trailingAnchor, constant: 10).isActive = true
        linkTextField.trailingAnchor.constraint(equalTo: linkView.trailingAnchor, constant: -20).isActive = true
        linkTextField.centerYAnchor.constraint(equalTo: linkView.centerYAnchor, constant: 1).isActive = true
        
        //MARK: note
        theStackView.addArrangedSubview(self.noteView)
        noteView.addSubview(noteLabel)
        noteView.addSubview(noteTextField)
        
        noteView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        noteView.isHidden = true
        
        noteLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 20).isActive = true
        noteLabel.centerYAnchor.constraint(equalTo: noteView.centerYAnchor).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        noteTextField.leadingAnchor.constraint(equalTo: noteLabel.trailingAnchor, constant: 10).isActive = true
        noteTextField.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -20).isActive = true
        noteTextField.centerYAnchor.constraint(equalTo: noteView.centerYAnchor, constant: 1).isActive = true
        
        //MARK: items
        theStackView.addArrangedSubview(self.itemView)
        itemView.addSubview(itemScrollView)
        itemScrollView.addSubview(imageButton)
        itemScrollView.addSubview(priceButton)
        itemScrollView.addSubview(linkButton)
        itemScrollView.addSubview(noteButton)
        self.addSubview(dropDownButton)
        
        itemScrollView.contentSize = CGSize(width: 200, height: 60)
        
        itemView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dropDownButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        dropDownButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownButton.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -20).isActive = true
        dropDownButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        
        itemScrollView.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemScrollView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor).isActive = true
        itemScrollView.trailingAnchor.constraint(equalTo: dropDownButton.leadingAnchor).isActive = true
        itemScrollView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        
        imageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: itemScrollView.centerYAnchor).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: itemScrollView.leadingAnchor, constant: 20).isActive = true
        
        priceButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        priceButton.centerYAnchor.constraint(equalTo: itemScrollView.centerYAnchor).isActive = true
        priceButton.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor, constant: 45).isActive = true
        
        linkButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        linkButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        linkButton.centerYAnchor.constraint(equalTo: itemScrollView.centerYAnchor).isActive = true
        linkButton.leadingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: 45).isActive = true
        
        noteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noteButton.centerYAnchor.constraint(equalTo: itemScrollView.centerYAnchor).isActive = true
        noteButton.leadingAnchor.constraint(equalTo: linkButton.leadingAnchor, constant: 45).isActive = true
    }
    
    //MARK: Helper for DropDownTableView
    var dropDown: DropDownView?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let newPoint = self.convert(point, to: dropDown!)
        if dropDown?.point(inside: newPoint, with: event) == true {
            return dropDown?.hitTest(newPoint, with: event)
        } else {
        }
        return super.hitTest(point, with: event)
    }
    
    
    //MARK: Enable Button Methods
    func disableButton(){
        self.wishButton.alpha = 0.5
        self.wishButton.isEnabled = false
    }
    
    func enableButton(){
        self.wishButton.alpha = 1.0
        self.wishButton.isEnabled = true
    }
    
    @objc func textFieldDidChange(){
        if self.wishNameTextField.text == "" {
            disableButton()
        } else {
            enableButton()
        }
    }
    //MARK: PriceTextField - formatter
    var amount: Int = 0
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.priceTextField {
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
        }
        return false
    }
    
    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amt = Double(amount/100) + Double(amount%100)/100
        return formatter.string(from: NSNumber(value: amt))
    }
    
    @objc func deleteImageButtonTapped(){
        UIView.animate(withDuration: 0.25) {
            self.imageContainerView.alpha = 0
            self.imageContainerView.isHidden = true
            self.deleteImageButton.isHidden = true
            self.wishImageView.isHidden = true
            self.theStackView.layoutIfNeeded()
        }
        self.onImageButtonTapped?(imageContainerView.frame.height, false)
    }
    
    //MARK: imageButtonTapped
    @objc func imageButtonTapped(){
        let imageViewIsHidden = imageContainerView.isHidden
        
        if imageViewIsHidden {
            
            self.imageButtonDelegate?.showImagePickerControllerActionSheet()
            self.onImageButtonTapped?(imageContainerView.frame.height, true)
        } else {
            
            self.imageButtonDelegate?.showImagePickerControllerActionSheet()
            self.onImageButtonTapped?(imageContainerView.frame.height, false)
            
        }
    }
    
    //MARK: priceButtonTapped
    @objc func priceButtonTapped(){
        
        let priceViewIsHidden = priceView.isHidden
        
        if priceViewIsHidden {
            UIView.animate(withDuration: 0.25) {
                self.priceView.alpha = 1
                self.priceView.isHidden = false
                self.theStackView.layoutIfNeeded()
            }
            self.onPriceButtonTapped?(priceView.frame.height, true)
        } else {
            UIView.animate(withDuration: 0.25) {
                self.priceView.alpha = 0
                self.priceView.isHidden = true
                self.theStackView.layoutIfNeeded()
            }
            self.onPriceButtonTapped?(priceView.frame.height, false)
            
        }
    }
    
    //MARK: linkButtonTapped
    @objc func linkButtonTapped(){
       let linkViewIsHidden = linkView.isHidden
        
        if linkViewIsHidden {
            UIView.animate(withDuration: 0.25) {
                self.linkView.alpha = 1
                self.linkView.isHidden = false
                self.theStackView.layoutIfNeeded()
            }
            self.onLinkButtonTapped?(linkView.frame.height, true)
        } else {
            UIView.animate(withDuration: 0.25) {
                self.linkView.alpha = 0
                self.linkView.isHidden = true
                self.theStackView.layoutIfNeeded()
            }
            self.onLinkButtonTapped?(linkView.frame.height, false)
            
        }
    }
    
    //MARK: noteButtonTapped
    @objc func noteButtonTapped(){
        
        let noteViewIsHidden = noteView.isHidden
        
        if noteViewIsHidden {
            UIView.animate(withDuration: 0.25) {
                self.noteView.alpha = 1
                self.noteView.isHidden = false
                self.theStackView.layoutIfNeeded()
            }
            self.onNoteButtonTapped?(noteView.frame.height, true)
        } else {
            UIView.animate(withDuration: 0.25) {
                self.noteView.alpha = 0
                self.noteView.isHidden = true
                self.theStackView.layoutIfNeeded()
            }
            self.onNoteButtonTapped?(noteView.frame.height, false)
            
        }
    }

    
    //MARK: wishButtonTapped
    @objc func wishButtonTapped(){
       print("wishButtonTapped")
        
        let name = self.wishNameTextField.text!
        let listIDX = self.selectedWishlistIDX!
        let image = self.wishImageView.image ?? UIImage()
        let link = self.linkTextField.text ?? "kein Link hinzugefügt"
        let price = self.priceTextField.text ?? ""
        let note = self.noteTextField.text ?? ""
        
        self.addWishDelegate?.addWishComplete(wishName: name, selectedWishlistIDX: listIDX, wishImage: image, wishLink: link, wishPrice: price, wishNote: note)
    }
    
}

extension WishView: SelectedWishlistProtocol {
    func didSelectWishlist(idx: Int) {
        print(idx)
        self.selectedWishlistIDX = idx
    }
}
