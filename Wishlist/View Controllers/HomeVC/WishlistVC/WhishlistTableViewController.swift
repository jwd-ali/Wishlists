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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable prefill tableview with cells
//        let v = UIView()
//        v.backgroundColor = .clear
//        tableView.tableFooterView = v
        
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
        return wishList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WhishCell.reuseID, for: indexPath) as! WhishCell
        
        
        let currentWish = self.wishList[indexPath.row]
        cell.label.text = currentWish.wishName
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
    init(withWishName name: String, checked: Bool) {
        super.init()
        wishName = name
        checkedStatus = checked
    }
}
