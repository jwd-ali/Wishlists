//
//  MakeWishViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 10.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class MakeWishViewController: UIViewController {
    
    let wishNameTextField: UITextField = {
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
    
    let linkTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Link hinzufügen"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext", size: 18)
        v.font = v.font?.withSize(18)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Preis hinzufügen"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext", size: 18)
        v.font = v.font?.withSize(18)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noticeTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .clear
        v.placeholder = "Notiz hinzufügen"
        v.textColor = .white
        v.font = UIFont(name: "AvenirNext", size: 18)
        v.font = v.font?.withSize(18)
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
    
    let wishButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "wishButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(wishButtonTapped), for: .touchUpInside)
        v.contentVerticalAlignment = .fill
        v.contentHorizontalAlignment = .fill
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
    
    var whishName: String? {
        get {
            self.wishNameTextField.text
        }
    }
    
    var dropDownButton = DropDownBtn()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the dropDownButton
        dropDownButton = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        dropDownButton.dropView.selectedWishlistDelegate = self
        dropDownButton.label.text = "Liste wählen"
        dropDownButton.listImage.image = UIImage(named: "iconRoundedImage")
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(visualEffectView)
        view.addSubview(grayView)
        
        view.addSubview(wishImage)
        view.addSubview(wishImageButton)
        
        view.addSubview(wishNameTextField)
        view.addSubview(linkTextField)
        view.addSubview(priceTextField)
        view.addSubview(noticeTextField)
        
        view.addSubview(linkImage)
        view.addSubview(priceImage)
        view.addSubview(noticeImage)
        
        view.addSubview(wishButton)
        view.addSubview(closeButton)
        
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // constrain blurrEffectView
        grayView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        grayView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        grayView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        grayView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true

        // constrain wishButton
        wishButton.rightAnchor.constraint(equalTo: grayView.rightAnchor).isActive = true
        wishButton.bottomAnchor.constraint(equalTo: grayView.bottomAnchor).isActive = true
        wishButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 72).isActive = true

//        // constrain dropDownbutton
//        dropDownButton.centerXAnchor.constraint(equalTo: self.grayView.centerXAnchor).isActive = true
//        dropDownButton.centerYAnchor.constraint(equalTo: self.grayView.centerYAnchor).isActive = true
//        dropDownButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
//        dropDownButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // constrain closeButton
        closeButton.leftAnchor.constraint(equalTo: grayView.leftAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: grayView.topAnchor).isActive = true
    }
    
    @objc private func wishImageButtonTapped(){
        print("wishImageButtonTapped")
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func wishButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
