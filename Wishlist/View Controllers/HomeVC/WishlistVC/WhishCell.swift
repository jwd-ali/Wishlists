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
    
    let wishImage: ShadowRoundedImageView = {
        let v = ShadowRoundedImageView()
        v.backgroundColor = .clear
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .cyan
        return v
    }()
    
    let wishImageHeight = CGFloat(80)
    
    var wishImageWidthConstraint: NSLayoutConstraint!
    
    //MARK: priceStack
    let priceView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
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
        setupLoadingAnimation()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    //MARK: setup Loading-Animation
    func setupLoadingAnimation(){

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
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(secondaryStackView)
        
        secondaryStackView.addArrangedSubview(imageContainerView)
        imageContainerView.addSubview(wishImage)
        
        secondaryStackViewHeightConstraint = secondaryStackView.heightAnchor.constraint(equalToConstant: 90)
        secondaryStackViewHeightConstraint.priority = .defaultHigh
        secondaryStackViewHeightConstraint.isActive = true
        
        secondaryStackView.addArrangedSubview(thirdStackView)
        
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
        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 15).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //constrain wish label
        let labelHeight = label.heightAnchor.constraint(equalToConstant: 50)
        labelHeight.priority = .defaultHigh
        labelHeight.isActive = true
        
        // constrain checkButton
        checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        let imageContainerHeight = imageContainerView.heightAnchor.constraint(equalToConstant: 90)
        imageContainerHeight.priority = .defaultHigh
        imageContainerHeight.isActive = true
        
        wishImage.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        wishImage.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        wishImage.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -10).isActive = true
        
        wishImageWidthConstraint = wishImage.widthAnchor.constraint(equalToConstant: wishImageHeight)
        wishImageWidthConstraint.isActive = true
        
        let imageHeight = wishImage.heightAnchor.constraint(equalToConstant: wishImageHeight)
        imageHeight.priority = .defaultHigh
        imageHeight.isActive = true
        
        // contrain priceView
        let priceViewHeight = priceView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
        priceViewHeight.priority = .defaultHigh
        priceViewHeight.isActive = true
        
        priceImage.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
        priceImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        priceImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: priceImage.trailingAnchor, constant: 10).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -10).isActive = true
        
        // constrain linkView
        let linkViewHeight = linkView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
        linkViewHeight.priority = .defaultHigh
        linkViewHeight.isActive = true
        
        linkImage.topAnchor.constraint(equalTo: linkView.topAnchor).isActive = true
        linkImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        linkImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        linkLabel.topAnchor.constraint(equalTo: linkView.topAnchor).isActive = true
        linkLabel.leadingAnchor.constraint(equalTo: linkImage.trailingAnchor, constant: 10).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: linkView.trailingAnchor, constant: -10).isActive = true

        // constrain noteView   
        let noteViewHeight = noteView.heightAnchor.constraint(equalToConstant: rowHeightThirdStackView)
        noteViewHeight.priority = .defaultHigh
        noteViewHeight.isActive = true
        
        noteImage.topAnchor.constraint(equalTo: noteView.topAnchor).isActive = true
        noteImage.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor).isActive = true
        noteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noteImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

        noteLabel.topAnchor.constraint(equalTo: noteView.topAnchor).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: noteImage.trailingAnchor, constant: 10).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -10).isActive = true
                
    }
    
    //MARK: set
    func set(image: UIImage) {
        let ratio = image.size.width / image.size.height
        wishImage.image = image
        wishImageWidthConstraint.constant = ratio * wishImageHeight
        
        // set ContainerView width and add 10 for spacing between items and image
        imageContainerWidthConstraint = imageContainerView.widthAnchor.constraint(equalToConstant: wishImageWidthConstraint.constant + 10)
        imageContainerWidthConstraint.priority = .defaultHigh
        imageContainerWidthConstraint.isActive = true
    }
    
    @objc func checkButtonTapped(){
        self.deleteWishCallback?()
        self.successAnimation.isHidden = false
        self.successAnimation.play()
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
