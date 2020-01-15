//
//  PopUpView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 21.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class PopUpView: UIView {
    
    let popUpTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Was wünschst du dir?"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 20)
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
        v.font = UIFont(name: "AvenirNext-Regular", size: 18)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Preis hinzufügen"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 18)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noticeTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Notiz hinzufügen"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext-Regular", size: 18)
        v.textAlignment = .left
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
    
    let noticeImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "notice")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishImage: UIImageView = {
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
    
    var whishName: String? {
        get {
            self.popUpTextField.text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        
        
        addSubview(grayView)
        addSubview(popUpTextField)
        addSubview(wishImage)
        addSubview(wishImageButton)
        addSubview(linkImage)
        addSubview(linkTextField)
        addSubview(priceImage)
        addSubview(priceTextField)
        addSubview(noticeImage)
        addSubview(noticeTextField)
        
        // constrain grayView
        grayView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        grayView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -300).isActive = true
        grayView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        grayView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true

        // constrain textField
        popUpTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popUpTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        popUpTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        popUpTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func wishImageButtonTapped(){
        print("wishImageButtonTapped")
    }
    
}
