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
        v.font = UIFont(name: "AvenirNext", size: 20)
        v.font = v.font?.withSize(20)
        v.textAlignment = .center
        v.placeholderColor(color: UIColor.white)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addLine(position: .LINE_POSITION_BOTTOM, color: .white, width: 2.5)
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
        
        // constrain grayView
        grayView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        grayView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
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
    
}
