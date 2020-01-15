//
//  WhishlistTableViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class WhishlistTableViewController: UITableViewController {

    public var wishList = [Wish]()
    
    // protocol / delegate pattern
    public var deleteWishDelegate: DeleteWishDelegate?
    
    let nightSky: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "nightSky")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let noWishes: UILabel = {
        let v = UILabel()
        v.text = "Du scheinst wunschlos glücklich zu sein!"
        v.font = UIFont(name: "AvenirNext-Regular", size: 16)
        v.textColor = .lightGray
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.rowHeight = 180
        
        // disable didSelectAt
        self.tableView.allowsSelection = false
        
//        self.tableView.separatorStyle = .none
        
        self.tableView.register(WhishCell.self, forCellReuseIdentifier: WhishCell.reuseID)
        
        // add top inset for tableview
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // show background image and text if wishlist is empty
        if wishList.count == 0 {
            view.addSubview(self.nightSky)
            view.addSubview(self.noWishes)
            
            nightSky.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nightSky.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
            nightSky.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
            nightSky.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
            
            
            noWishes.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noWishes.bottomAnchor.constraint(equalTo: nightSky.bottomAnchor, constant: 10).isActive = true
            
        } else {
            nightSky.removeFromSuperview()
            noWishes.removeFromSuperview()
        }
        return wishList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WhishCell.reuseID, for: indexPath) as! WhishCell
        
        
        let currentWish = self.wishList[indexPath.row]
        if currentWish.wishImage == UIImage(named: "image"){
            cell.wishImage.image = .none
        }else {
            cell.wishImage.image = currentWish.wishImage
        }
        cell.label.text = currentWish.wishName
        
        cell.linkLabel.text = currentWish.wishLink
        print(cell.linkLabel.text!)
        cell.priceLabel.text = currentWish.wishPrice
        cell.noteLabel.text = currentWish.wishNote
        cell.backgroundColor = .clear
        cell.checkButton.setBackgroundImage(UIImage(named: "boxUnchecked"), for: .normal)
        
        // DonMag3 - tapping the checkbox in the wish cell will call back here
        // and we tell the delegate to delete the wish
        cell.deleteWishCallback = {
            self.deleteWishDelegate?.deleteWish(indexPath.row)
        }
        
        return cell
    }

}

class Wish: NSObject {
    public var wishName : String?
    public var checkedStatus : Bool?
    public var wishLink : String?
    public var wishPrice : String?
    public var wishNote : String?
    public var wishImage : UIImage?
    
    init(withWishName name: String, link: String, price: String, note: String, image: UIImage, checked: Bool) {
        super.init()
        wishName = name
        checkedStatus = checked
        wishLink = link
        wishPrice = price
        wishNote = note
        wishImage = image
    }
}
