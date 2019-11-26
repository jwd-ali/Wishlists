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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable prefill tableview with cells
        let v = UIView()
        v.backgroundColor = .clear
        tableView.tableFooterView = v
        
        // disable didSelectAt
        self.tableView.allowsSelection = false
        
        self.tableView.register(WhishCell.self, forCellReuseIdentifier: WhishCell.reuseID)
        self.wishList.append(Wish(withWishName: "Test"))
        
        // add top inset for tavleview
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
        
        
        
        
        return cell
    }

}

class Wish: NSObject {
    public var wishName : String?
    init(withWishName name: String) {
        super.init()
        wishName = name
    }
}
