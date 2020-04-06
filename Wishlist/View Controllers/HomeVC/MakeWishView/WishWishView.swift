//
//  WishWishView.swift
//  Wishlists
//
//  Created by Christian Konnerth on 02.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

class WishView: UIView, UITextFieldDelegate { 
    
//    public var height = CGFloat(0)
    
    //MARK: StackView
    let theStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Image
    
    
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
    
    //MARK: ItemView
    let itemView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let itemViewHeight = 60
    
    let imageButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "photo"), for: .normal)
        v.tintColor = UIColor.white
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
        v.tintColor = UIColor.white
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
        v.tintColor = UIColor.white
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
        v.tintColor = UIColor.white
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(noteButtonTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: ImageView
    let imageView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
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
        v.placeholderColor(color: .lightGray)
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 17)
        v.textAlignment = .left
        v.keyboardAppearance = .dark
        v.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    //MARK: PriceView
    let priceView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceViewHeight = 50
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.text = "Preis:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Preis hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.lightGray)
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .right
        v.keyboardType = .numberPad
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: LinkView
    let linkView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.text = "Link:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Link hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.lightGray)
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: NoteView
    let noteView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.text = "Link:"
        v.textAlignment = .left
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Notiz hinzufügen"
        v.textColor = .white
        v.placeholderColor(color: UIColor.lightGray)
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
    
    var onPriceButtonTapped: ((_ height: CGFloat, _ isHidden: Bool) -> Void)?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        self.height += CGFloat(self.wishViewHeight)
        
        wishButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        wishButton.trailingAnchor.constraint(equalTo: wishView.trailingAnchor, constant: -20).isActive = true
        wishButton.centerYAnchor.constraint(equalTo: wishView.centerYAnchor, constant: 10).isActive = true
        
        wishNameTextField.leadingAnchor.constraint(equalTo: wishView.leadingAnchor, constant: 20).isActive = true
        wishNameTextField.centerYAnchor.constraint(equalTo: wishView.centerYAnchor, constant: 10).isActive = true
        wishNameTextField.trailingAnchor.constraint(equalTo: wishButton.leadingAnchor, constant: -20).isActive = true
        
        theStackView.addArrangedSubview(self.priceView)
        priceView.addSubview(priceLabel)
        priceView.addSubview(priceTextField)
        
        priceView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        priceView.isHidden = true
        
        priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 20).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor).isActive = true
        
        priceTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10).isActive = true
        priceTextField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -195).isActive = true
        priceTextField.centerYAnchor.constraint(equalTo: priceView.centerYAnchor, constant: 1).isActive = true
        
        
        theStackView.addArrangedSubview(self.itemView)
        itemView.addSubview(imageButton)
        itemView.addSubview(priceButton)
        itemView.addSubview(linkButton)
        itemView.addSubview(noteButton)
        self.addSubview(dropDownButton)
        
        itemView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        imageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 20).isActive = true
        
        priceButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        priceButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        priceButton.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor, constant: 50).isActive = true
        
        linkButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        linkButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        linkButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        linkButton.leadingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: 50).isActive = true
        
        noteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noteButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        noteButton.leadingAnchor.constraint(equalTo: linkButton.leadingAnchor, constant: 50).isActive = true
        
        dropDownButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        dropDownButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dropDownButton.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -20).isActive = true
        dropDownButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
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
    
    //MARK: imageButtonTapped
    @objc func imageButtonTapped(){
        
    }
    
    //MARK: priceButtonTapped
    @objc func priceButtonTapped(){
        let priceViewIsHidden = priceView.isHidden
        priceView.isHidden = false
        if priceViewIsHidden {
            self.onPriceButtonTapped?(priceView.frame.height, true)
        } else {
            self.onPriceButtonTapped?(priceView.frame.height, false)
            priceView.isHidden = true
        }
    }
    
    //MARK: linkButtonTapped
    @objc func linkButtonTapped(){
        
    }
    
    //MARK: noteButtonTapped
    @objc func noteButtonTapped(){
        
    }
    
    //MARK: wishButtonTapped
    @objc func wishButtonTapped(){
       print("wishButtonTapped")
    }
    
    
    //MARK: wishImageButtonTapped
    @objc func wishImageButtonTapped(){
        print("wishImageButtonTapped")
    }
}
