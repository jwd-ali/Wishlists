//
//  WhishlistTableViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class WhishlistTableViewController: UITableViewController {

    public var wishData = [
        Wish(withWishName: "Ultra Boost Kith Aspen", link: "www.adidas.com", price: "180,00€", note: "EU 44 / US 10", image: UIImage(named: "testImageShoes-1")!, checked: false),
        
//        Wish(withWishName: "Apple Hoodie", link: "www.adidas.com", price: "180,00€", note: "US 44", image: UIImage(named: "testImage")!, checked: false)
    ]
    
//    public var wishData = [Wish]()
    
    var tableViewIsEmpty: ((Bool) -> Void)?

    // protocol / delegate pattern
    public var deleteWishDelegate: DeleteWishDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.rowHeight = 140

        // disable didSelectAt
        self.tableView.allowsSelection = false
        
        self.tableView.register(WhishCell.self, forCellReuseIdentifier: WhishCell.reuseID)
        
        // add top inset for tableview
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wishData.count == 0 {
            tableViewIsEmpty?(true)
        } else {
            tableViewIsEmpty?(false)
        }
        return wishData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WhishCell.reuseID, for: indexPath) as! WhishCell
        
        let currentWish = self.wishData[indexPath.row]
        if currentWish.wishImage == UIImage(named: "image"){
            cell.wishImage.image = .none
        }else {
            cell.wishImage.image = currentWish.wishImage
        }
        cell.label.text = currentWish.wishName
        
        cell.linkLabel.text = currentWish.wishLink
        cell.priceLabel.text = currentWish.wishPrice
        cell.noteLabel.text = currentWish.wishNote
        cell.backgroundColor = .clear
        
        // DonMag3 - tapping the checkbox in the wish cell will call back here
        // and we tell the delegate to delete the wish
        cell.deleteWishCallback = {
            self.deleteWishDelegate?.deleteWish(indexPath.row)
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
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
