//
//  WhishlistTableViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class WhishlistTableViewController: UITableViewController {


    
    public var wishData = [Wish]()
    
    var tableViewIsEmpty: ((Bool) -> Void)?

    // protocol / delegate pattern
    public var deleteWishDelegate: DeleteWishDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        

        // disable didSelectAt
        self.tableView.allowsSelection = false
        
        self.tableView.register(WhishCell.self, forCellReuseIdentifier: WhishCell.reuseID)
        
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
        
        // reset height constraint
        cell.secondaryStackViewHeightConstraint.constant = 0
        cell.thrirdStackViewHeightConstraint.constant = 0
        
        if currentWish.note == "" {
            cell.noteView.isHidden = true
        } else {
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        if currentWish.price == "" {
            cell.priceView.isHidden = true
        } else {
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        if currentWish.link == "" {
            cell.linkView.isHidden = true
        } else {
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        
        if !currentWish.image.hasContent {
            cell.imageContainerView.isHidden = true
        }else {
            cell.set(image: currentWish.image)
        }
        
        
        // everything empty -> hide secondary StackView
        if currentWish.note.isEmpty
            && currentWish.price.isEmpty
            && currentWish.link.isEmpty
            && !currentWish.image.hasContent {

            cell.secondaryStackView.isHidden = true
        }
        
        // Image or third StackView is filled -> show secondary StackView + activate constraint with height
        if (!currentWish.note.isEmpty
            && !currentWish.price.isEmpty
            && !currentWish.link.isEmpty)
            || currentWish.image.hasContent {
            cell.secondaryStackViewHeightConstraint.constant = 90
            cell.secondaryStackView.isHidden = false

        }
        
        cell.wishImage.image = currentWish.image
        
        cell.label.text = currentWish.name
        
        cell.linkLabel.text = currentWish.link
        cell.priceLabel.text = currentWish.price
        cell.noteLabel.text = currentWish.note
        cell.backgroundColor = .clear
        
        // tapping the checkbox in the wish cell will call back here
        // and we tell the delegate to delete the wish
        cell.deleteWishCallback = {
            self.deleteWishDelegate?.deleteWish(indexPath.row)
        }
        
        return cell
    }

}

