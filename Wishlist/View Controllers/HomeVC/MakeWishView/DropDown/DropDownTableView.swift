//
//  DropDownTableView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 29.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

//MARK: Protocols

protocol SelectedWishlistProtocol {
    func didSelectWishlist(idx: Int)
}

protocol DropDownProtocol {
    func dropDownPressed(string : String, image: UIImage)
}

//MARK: DropDownView
class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {

    var dropOptions = [DropDownOption]()
    
    var tableView = UITableView()
    
    var delegate : DropDownProtocol!
    
    var selectedWishlistDelegate: SelectedWishlistProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.darkCustom
        self.tableView.layer.borderColor = UIColor.darkCustom.cgColor
        self.tableView.layer.borderWidth = 1.0
        self.tableView.layer.cornerRadius = 3
        
        self.tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseID)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseID, for: indexPath) as! DropDownCell
        
        cell.label.text = dropOptions[indexPath.row].name
        cell.listImage.image = dropOptions[indexPath.row].image
//        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate.dropDownPressed(string: dropOptions[indexPath.row].name, image: dropOptions[indexPath.row].image)

        self.selectedWishlistDelegate?.didSelectWishlist(idx: indexPath.row)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: DropDownButton

class DropDownBtn: UIButton, DropDownProtocol {
    
    let label: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .darkCustom
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let listImage: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    func dropDownPressed(string: String, image: UIImage) {
        self.setTitle("", for: .normal)
        self.label.text = string
        self.listImage.image = image
        self.dismissDropDown()
    }
    
    var dropView = DropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.darkCustom.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3
        
        
        // add image
        self.addSubview(listImage)
        self.listImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.listImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.listImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        self.listImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // add label
        self.addSubview(label)
        self.label.leadingAnchor.constraint(equalTo: self.listImage.leadingAnchor, constant: 32).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func removeFromSuperview() {        
        dropView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = false
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = false
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = false
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y -= self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y += self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dropView.center.y += self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
