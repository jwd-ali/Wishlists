//
//  WishView.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 01.05.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerDelegate {
    func showImagePickerControllerActionSheet()
}

protocol AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?)
}

class WishView: UIView, UITextFieldDelegate {
    
    let backgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return v
    }()
    
    //MARK: ImageView
    var onImageButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    let wishImageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        v.backgroundColor = .black
        v.layer.cornerRadius = 5
        return v
    }()
    
    let shadowView: ShadowView = {
        let v = ShadowView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
        
    let deleteImageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        v.tintColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(deleteImageButtonTapped), for: .touchUpInside)
        return v
    }()
    
    var onDeleteImageButtonTapped: (() -> Void)?
    
    let wishNameTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Was wünschst du dir?"
        v.textColor = .darkCustom
        v.font = UIFont(name: "AvenirNext-Bold", size: 19)
        v.tintColor = .darkCustom
        v.textAlignment = .left
        v.keyboardAppearance = .default
        v.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.adjustsFontSizeToFitWidth = true
        v.minimumFontSize = 17
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
        v.textAlignment = .left
        v.keyboardType = .numberPad
        v.keyboardAppearance = .default
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: NoteView
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
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .left
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
    
    let nextButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(UIImage(systemName: "arrow.right.square.fill"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return v
    }()
    var onNextButtonTapped: (() -> Void)?
    
    let prevButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(UIImage(systemName: "arrow.left.square.fill"), for: .normal)
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let addImageButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.setImage(UIImage(named: "photo"), for: .normal)
        v.setTitle("Bild hinzufügen", for: .normal)
        v.setTitleColor(UIColor.lightGray, for: .normal)
        v.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 13)
        v.titleLabel?.numberOfLines = 0
        v.titleLabel?.textAlignment = .center
        v.layer.borderColor = UIColor.darkCustom.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 3
        v.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return v
    }()
    var onPrevButtonTapped: (() -> Void)?
    
    var dataSourceArray = [Wishlist]()
    
    var addWishDelegate: AddWishDelegate?
    
    var imagePickerDelegate: ImagePickerDelegate?
    
    var selectedWishlistIDX: Int?
    
    var link = ""
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupViews()
    
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()
        
        showAddImageButton()
        hideImageView()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setupViews
    func setupViews(){
        
        addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundView.addSubview(wishNameTextField)
        wishNameTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20).isActive = true
        wishNameTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        wishNameTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20).isActive = true
        
        //MARK: image
        backgroundView.addSubview(shadowView)
        backgroundView.addSubview(wishImageView)
        backgroundView.addSubview(deleteImageButton)
        backgroundView.addSubview(addImageButton)
        
        wishImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        wishImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        wishImageView.topAnchor.constraint(equalTo: wishNameTextField.bottomAnchor, constant: 25).isActive = true
        wishImageView.leadingAnchor.constraint(equalTo: wishNameTextField.leadingAnchor).isActive = true
        
        shadowView.heightAnchor.constraint(equalTo: wishImageView.heightAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalTo: wishImageView.widthAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: wishImageView.topAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: wishImageView.leadingAnchor).isActive = true
    
        deleteImageButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteImageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteImageButton.topAnchor.constraint(equalTo: wishImageView.topAnchor, constant: -10).isActive = true
        deleteImageButton.trailingAnchor.constraint(equalTo: wishImageView.trailingAnchor, constant: 10).isActive = true
        
        addImageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addImageButton.topAnchor.constraint(equalTo: wishNameTextField.bottomAnchor, constant: 25).isActive = true
        addImageButton.leadingAnchor.constraint(equalTo: wishNameTextField.leadingAnchor).isActive = true
        addImageButton.isHidden = true
        
        //MARK: price
        backgroundView.addSubview(priceLabel)
        backgroundView.addSubview(priceTextField)
        
        priceLabel.leadingAnchor.constraint(equalTo: wishImageView.trailingAnchor, constant: 30).isActive = true
        priceLabel.topAnchor.constraint(equalTo: wishImageView.topAnchor, constant: 10).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        priceTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10).isActive = true
        priceTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30).isActive = true
        priceTextField.topAnchor.constraint(equalTo: priceLabel.topAnchor).isActive = true
        
        //MARK: note
        backgroundView.addSubview(noteLabel)
        backgroundView.addSubview(noteTextField)
        
        noteLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        noteLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
     
        noteTextField.leadingAnchor.constraint(equalTo: noteLabel.trailingAnchor, constant: 10).isActive = true
        noteTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30).isActive = true
        noteTextField.topAnchor.constraint(equalTo: noteLabel.topAnchor).isActive = true
                
        backgroundView.addSubview(prevButton)
        backgroundView.addSubview(nextButton)
        
        prevButton.leadingAnchor.constraint(equalTo: wishImageView.leadingAnchor).isActive = true
        prevButton.topAnchor.constraint(equalTo: wishImageView.bottomAnchor, constant: 10).isActive = true
        prevButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        nextButton.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: 10).isActive = true
        nextButton.topAnchor.constraint(equalTo: prevButton.topAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundView.addSubview(wishButton)
        self.addSubview(dropDownButton)
        
        dropDownButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        dropDownButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownButton.centerYAnchor.constraint(equalTo: prevButton.centerYAnchor).isActive = true
        dropDownButton.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        
        wishButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        wishButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20).isActive = true
        wishButton.centerYAnchor.constraint(equalTo: prevButton.centerYAnchor).isActive = true
        disableButton()
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
        self.onDeleteImageButtonTapped?()
        hideImageView()
        showAddImageButton()
    }
    
    func setImageFromPhotos(image: UIImage){
        wishImageView.image = image
        hideAddImageButton()
        showImageView()
    }
    
    func showAddImageButton(){
        addImageButton.isHidden = false
    }
    
    func hideAddImageButton(){
        addImageButton.isHidden = true
    }
    
    @objc func addImageButtonTapped(){
        self.imagePickerDelegate?.showImagePickerControllerActionSheet()
    }
    
    func hideImageView(){
        shadowView.isHidden = true
        wishImageView.isHidden = true
        deleteImageButton.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
    }
    
    func showImageView(){
        shadowView.isHidden = false
        wishImageView.isHidden = false
        deleteImageButton.isHidden = false
        prevButton.isHidden = false
        nextButton.isHidden = false
    }
    
    @objc func prevButtonTapped(){
        self.onPrevButtonTapped?()
    }
    
    @objc func nextButtonTapped(){
        self.onNextButtonTapped?()
    }
    
    //MARK: wishButtonTapped
    @objc func wishButtonTapped(){
       print("wishButtonTapped")
        let name = self.wishNameTextField.text ?? ""
        let listIDX = self.selectedWishlistIDX ?? 0
        let image = self.wishImageView.image ?? UIImage()
        let link = self.link
        let price = self.priceTextField.text ?? ""
        let note = self.noteTextField.text ?? ""

        self.addWishDelegate?.addWishComplete(wishName: name, selectedWishlistIDX: listIDX, wishImage: image, wishLink: link, wishPrice: price, wishNote: note)
    }
    
}

extension WishView: SelectedWishlistProtocol {
    func didSelectWishlist(idx: Int) {
        self.selectedWishlistIDX = idx
    }
}
