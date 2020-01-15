//
//  WhishCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class WhishCell: UITableViewCell {
    
    // change "callback" to "deleteWishCallback" so we know what its purpose
    var deleteWishCallback : (() -> ())?
    
    let label: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext-Medium", size: 23)
        v.textColor = .white
        v.font = v.font.withSize(23)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let checkButton: UIButton =  {
        let v = UIButton()
        v.backgroundColor = .darkGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setBackgroundImage(UIImage(named: "boxUnchecked"), for: .normal)
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
    
    let emptyImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .lightGray
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkLabel: UITextView = {
        let v = UITextView()
        v.backgroundColor = .clear
        v.text = "Link"
        v.textColor = .lightGray
        v.font = UIFont(name: "AvenirNext-Regular", size: 23)
        v.textAlignment = .right
        v.isSelectable = false
        v.isScrollEnabled = false
        v.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
//        v.attributedText = NSAttributedString(string: "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
//        v.text = "Preis"
        v.textColor = .lightGray
        v.font = UIFont(name: "AvenirNext-Regular", size: 18)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
//        v.text = "Notiz"
        v.textColor = .lightGray
        v.font = UIFont(name: "AvenirNext-Regular", size: 18)
        v.textAlignment = .right
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let linkImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "link")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "price")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "note")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    public static let reuseID = "WhishCell"

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(label)
        contentView.addSubview(checkButton)
        contentView.addSubview(emptyImage)
        contentView.addSubview(wishImage)
        
        
        contentView.addSubview(linkImage)
        contentView.addSubview(priceImage)
        contentView.addSubview(noteImage)
        
        contentView.addSubview(linkLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(noteLabel)
        
        //constrain wish label
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        // constrain checkButton
        checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
 
        // constrain wishImage
        wishImage.topAnchor.constraint(equalTo: label.topAnchor, constant: 52).isActive = true
        wishImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        wishImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        wishImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // constain emptyImage
        emptyImage.topAnchor.constraint(equalTo: wishImage.topAnchor, constant: 10).isActive = true
        emptyImage.bottomAnchor.constraint(equalTo: wishImage.bottomAnchor, constant: -10).isActive = true
        emptyImage.leadingAnchor.constraint(equalTo: wishImage.leadingAnchor, constant: 10).isActive = true
        emptyImage.trailingAnchor.constraint(equalTo: wishImage.trailingAnchor, constant: -10).isActive = true
        
        // constrain linkImage
        linkImage.topAnchor.constraint(equalTo: label.topAnchor, constant: 45).isActive = true
        linkImage.leadingAnchor.constraint(equalTo: wishImage.leadingAnchor, constant: 90).isActive = true
        linkImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        // constrain priceImage
        priceImage.topAnchor.constraint(equalTo: linkImage.topAnchor, constant: 35).isActive = true
        priceImage.leadingAnchor.constraint(equalTo: wishImage.leadingAnchor, constant: 90).isActive = true
        priceImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        // constrain noteImage
        noteImage.topAnchor.constraint(equalTo: priceImage.topAnchor, constant: 35).isActive = true
        noteImage.leadingAnchor.constraint(equalTo: wishImage.leadingAnchor, constant: 90).isActive = true
        noteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noteImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // constrain linkLabel
        linkLabel.topAnchor.constraint(equalTo: linkImage.topAnchor).isActive = true
        linkLabel.leadingAnchor.constraint(equalTo: linkImage.leadingAnchor, constant: 30).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        // constrain priceLabel
        priceLabel.topAnchor.constraint(equalTo: linkLabel.topAnchor, constant: 35).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: linkImage.leadingAnchor, constant: 30).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        // constrain noteLabel
        noteLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 35).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: linkImage.leadingAnchor, constant: 30).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
    }
    
    @objc func checkButtonTapped(){
        self.checkButton.setBackgroundImage(UIImage(named: "boxChecked"), for: .normal)
        self.checkButton.alpha = 0
        self.checkButton.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)

        UIView.animate(withDuration: 0.3, animations: {
            self.checkButton.alpha = 1
            self.checkButton.transform = CGAffineTransform.identity
        }) { (_) in
            // DonMag3 - tell the callback to delete this wish
            self.deleteWishCallback?()
        }
    }
}


// extension for "check" function
extension UITableViewCell {
    var tableView: UITableView? {
        return (next as? UITableView) ?? (parentViewController as? UITableViewController)?.tableView
    }

    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
