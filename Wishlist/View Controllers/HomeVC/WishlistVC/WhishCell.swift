//
//  WhishCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import Lottie

class WhishCell: UITableViewCell {
    
    var deleteWishCallback : (() -> ())?
    
    //MARK: StackViews
    let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.addBackgroundColorWithTopCornerRadius(color: .orange)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var mainStackViewHeightConstraint: NSLayoutConstraint!
    
    let secondaryStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.addBackgroundColorWithTopCornerRadius(color: .cyan)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var secondaryStackViewHeightConstraint: NSLayoutConstraint!
    
    let thirdStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.addBackgroundColorWithTopCornerRadius(color: .red)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var thrirdStackViewHeightConstraint: NSLayoutConstraint!
    
    let rowHeightThirdStackView = CGFloat(30)
    
    //MARK: Label
    let label: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext-Bold", size: 19)
        v.textColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var labelHeightConatraint: NSLayoutConstraint!
    
    //MARK: checkButton
    lazy var checkButton: UIButton =  {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "circleUnchecked"), for: .normal)
        v.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: Image
    let imageContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var imageContainerWidthConstraint: NSLayoutConstraint!
    var imageContainerHeightConstraint: NSLayoutConstraint!
    
    let wishImage: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 3
        return v
    }()
    
//    let shadowLayer: ShadowView = {
//        let v = ShadowView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
    
    var shadowLayerWidthConstraint: NSLayoutConstraint!
    var shadowHeightConstraint: NSLayoutConstraint!
    
    let wishImageHeight = CGFloat(80)
    var imageHeightConstraint: NSLayoutConstraint!
    
    var wishImageWidthConstraint: NSLayoutConstraint!
    
    //MARK: priceStack
    let priceView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
//
//    var priceViewHeightConstraint: NSLayoutConstraint!
    
    let priceImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "eurosign.circle")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .darkCustom
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
        v.textColor = .darkCustom
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    //MARK: linkStack
    let linkView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
//    var linkViewHeightConstraint: NSLayoutConstraint!
    
    let linkLabel: UITextView = {
            let v = UITextView()
            v.backgroundColor = .clear
            v.text = "Link"
            v.textColor = .darkCustom
            v.font = UIFont(name: "AvenirNext-Regular", size: 15)
            v.textAlignment = .left
            v.isSelectable = false
            v.isScrollEnabled = false
            let padding = v.textContainer.lineFragmentPadding
            v.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    //        v.attributedText = NSAttributedString(string: "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
    
    let linkImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "link")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    //MARK: noteStack
    let noteView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
//    var noteViewHeightConstraint: NSLayoutConstraint!
    
    let noteLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
        v.textColor = .darkCustom
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textAlignment = .left
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let noteImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let successAnimation = AnimationView(name: "successAnimation")
    
    public static let reuseID = "WhishCell"

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        setupViews()
        setupSuccessAnimation()
        
    }
    
    
    //MARK: setup Success-Animation
    func setupSuccessAnimation(){

        successAnimation.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(successAnimation)
       
        successAnimation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -30).isActive = true
        successAnimation.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        successAnimation.widthAnchor.constraint(equalToConstant: 160).isActive = true
        successAnimation.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        successAnimation.isHidden = true
        successAnimation.loopMode = .playOnce
    }
    
    func setupViews(){
        
        contentView.addSubview(checkButton)
        contentView.addSubview(mainStackView)
        
        // main StackView
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(secondaryStackView)
        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 15).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        mainStackViewHeightConstraint = mainStackView.heightAnchor.constraint(equalToConstant: 50)
        mainStackViewHeightConstraint.priority = .defaultHigh
        mainStackViewHeightConstraint.isActive = true
        
        //constrain wish label
        labelHeightConatraint = label.heightAnchor.constraint(equalToConstant: 50)
        labelHeightConatraint.priority = .defaultHigh
        labelHeightConatraint.isActive = true
        
        // constrain checkButton
        checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // 2nd StackView
        secondaryStackView.addArrangedSubview(imageContainerView)
//        imageContainerView.addSubview(shadowLayer)
        imageContainerView.addSubview(wishImage)
        
        secondaryStackViewHeightConstraint = secondaryStackView.heightAnchor.constraint(equalToConstant: 90)
        secondaryStackViewHeightConstraint.priority = .defaultHigh
        secondaryStackViewHeightConstraint.isActive = true
        
        secondaryStackView.addArrangedSubview(thirdStackView)
        
        // 3rd StackView
        thrirdStackViewHeightConstraint = thirdStackView.heightAnchor.constraint(equalToConstant: 90)
        thrirdStackViewHeightConstraint.priority = .defaultHigh
        thrirdStackViewHeightConstraint.isActive = true
        
        thirdStackView.addArrangedSubview(priceView)
        priceView.addSubview(priceImage)
        priceView.addSubview(priceLabel)
        
        thirdStackView.addArrangedSubview(linkView)
        linkView.addSubview(linkImage)
        linkView.addSubview(linkLabel)
        
        thirdStackView.addArrangedSubview(noteView)
        noteView.addSubview(noteImage)
        noteView.addSubview(noteLabel)
    
        imageContainerHeightConstraint = imageContainerView.heightAnchor.constraint(equalToConstant: 90)
        imageContainerHeightConstraint.priority = .defaultHigh
        imageContainerHeightConstraint.isActive = true
        
        wishImage.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        wishImage.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        wishImage.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -10).isActive = true
        
        wishImageWidthConstraint = wishImage.widthAnchor.constraint(equalToConstant: wishImageHeight)
        wishImageWidthConstraint.isActive = true
        
        imageHeightConstraint = wishImage.heightAnchor.constraint(equalToConstant: wishImageHeight)
        imageHeightConstraint.priority = .defaultHigh
        imageHeightConstraint.isActive = true
        
//        shadowLayer.leadingAnchor.constraint(equalTo: wishImage.leadingAnchor).isActive = true
//        shadowLayer.topAnchor.constraint(equalTo: wishImage.topAnchor).isActive = true
//        shadowLayer.bottomAnchor.constraint(equalTo: wishImage.bottomAnchor).isActive = true
        
//        shadowLayerWidthConstraint = shadowLayer.widthAnchor.constraint(equalToConstant: wishImageHeight)
//        shadowLayerWidthConstraint.isActive = true
//        
//        shadowHeightConstraint = shadowLayer.heightAnchor.constraint(equalToConstant: wishImageHeight)
//        shadowHeightConstraint.priority = .defaultHigh
//        shadowHeightConstraint.isActive = true
        
//        // contrain priceView
//        priceViewHeightConstraint = priceView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
//        priceViewHeightConstraint.priority = .defaultHigh
//        priceViewHeightConstraint.isActive = true
        
        priceImage.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
        priceImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        priceImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: priceImage.trailingAnchor, constant: 10).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -10).isActive = true
        
//        // constrain linkView
//        linkViewHeightConstraint = linkView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
//        linkViewHeightConstraint.priority = .defaultHigh
//        linkViewHeightConstraint.isActive = true
        
        linkImage.topAnchor.constraint(equalTo: linkView.topAnchor).isActive = true
        linkImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        linkImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        linkLabel.topAnchor.constraint(equalTo: linkView.topAnchor).isActive = true
        linkLabel.leadingAnchor.constraint(equalTo: linkImage.trailingAnchor, constant: 10).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: linkView.trailingAnchor, constant: -10).isActive = true

//        // constrain noteView   
//        noteViewHeightConstraint = noteView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
//        noteViewHeightConstraint.priority = .defaultHigh
//        noteViewHeightConstraint.isActive = true
        
        noteImage.topAnchor.constraint(equalTo: noteView.topAnchor).isActive = true
        noteImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        noteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noteImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        noteLabel.topAnchor.constraint(equalTo: noteView.topAnchor).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: noteImage.trailingAnchor, constant: 10).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -10).isActive = true
        
        // set ContainerView width and add 10 for spacing between items and image
        imageContainerWidthConstraint = imageContainerView.widthAnchor.constraint(equalToConstant: wishImageWidthConstraint.constant + 10)
        imageContainerWidthConstraint.priority = .defaultHigh
        imageContainerWidthConstraint.isActive = true
                
    }
    
    //MARK: set
    func set(image: UIImage) {
        let ratio = image.size.width / image.size.height
        wishImage.image = image
        wishImageWidthConstraint.constant = ratio * wishImageHeight

        imageContainerWidthConstraint.constant = wishImageWidthConstraint.constant + 10
    }
    
    @objc func checkButtonTapped(){
        
        self.successAnimation.isHidden = false
        self.successAnimation.play { (completion) in
            if completion {
                self.deleteWishCallback?()
            }
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
