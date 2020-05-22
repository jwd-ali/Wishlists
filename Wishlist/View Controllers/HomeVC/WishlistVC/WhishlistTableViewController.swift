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
        
        cell.label.text = currentWish.name
        
        cell.linkLabel.text = currentWish.link
        cell.priceLabel.text = currentWish.price
        cell.noteLabel.text = currentWish.note
        cell.wishImage.image = currentWish.image
        
        cell.setupSuccessAnimation()
        
        // reset height constraint
        cell.mainStackViewHeightConstraint.constant = cell.labelHeightConatraint.constant
        cell.secondaryStackViewHeightConstraint.constant = 0
        cell.secondaryStackView.isHidden = true
        cell.thrirdStackViewHeightConstraint.constant = 0
        cell.thirdStackView.isHidden = true
        
        cell.imageContainerWidthConstraint.constant = 0
        cell.imageContainerHeightConstraint.constant = 0
        cell.wishImageWidthConstraint.constant = 0
        cell.imageHeightConstraint.constant = 0
        cell.imageContainerView.isHidden = true
        
        cell.shadowLayerWidthConstraint.constant = 0
        cell.shadowHeightConstraint.constant = 0
        cell.shadowLayer.isHidden = true
        
        cell.priceView.isHidden = true
//        cell.priceViewHeightConstraint.constant = 0
        cell.linkView.isHidden = true
//        cell.linkViewHeightConstraint.constant = 0
        cell.noteView.isHidden = true
//        cell.noteViewHeightConstraint.constant = 0

        
        if currentWish.image.hasContent {
            cell.secondaryStackView.isHidden = false
            cell.secondaryStackViewHeightConstraint.constant = cell.rowHeightThirdStackView * 3
            cell.imageContainerView.isHidden = false
            
            let ratio = currentWish.image.size.width / currentWish.image.size.height
            cell.wishImage.image = currentWish.image
            cell.wishImageWidthConstraint.constant = ratio * cell.wishImageHeight
            cell.imageContainerWidthConstraint.constant = cell.wishImageWidthConstraint.constant + 10
            cell.imageContainerHeightConstraint.constant = cell.rowHeightThirdStackView * 3
            cell.imageHeightConstraint.constant = cell.wishImageHeight
            
            cell.shadowLayerWidthConstraint.constant = cell.wishImageWidthConstraint.constant
            cell.shadowHeightConstraint.constant = cell.imageContainerHeightConstraint.constant
            cell.shadowLayer.isHidden = false
        }
        
        if currentWish.price != "" {
            cell.priceView.isHidden = false
//            cell.priceViewHeightConstraint.constant = cell.rowHeightThirdStackView
            
            cell.secondaryStackView.isHidden = false
            cell.thirdStackView.isHidden = false
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        
        if currentWish.link != "" {
            cell.linkView.isHidden = false
//            cell.linkViewHeightConstraint.constant = cell.rowHeightThirdStackView
            
            cell.secondaryStackView.isHidden = false
            cell.thirdStackView.isHidden = false
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        
        if currentWish.note != "" {
            cell.noteView.isHidden = false
//            cell.noteViewHeightConstraint.constant = cell.rowHeightThirdStackView
            
            cell.secondaryStackView.isHidden = false
            cell.thirdStackView.isHidden = false
            cell.secondaryStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
            cell.thrirdStackViewHeightConstraint.constant += cell.rowHeightThirdStackView
        }
        
        cell.mainStackViewHeightConstraint.constant += cell.secondaryStackViewHeightConstraint.constant
        print(cell.mainStackViewHeightConstraint.constant)
        
            
        // tapping the checkbox in the wish cell will call back here
        // and we tell the delegate to delete the wish
        cell.deleteWishCallback = {
            self.deleteWishDelegate?.deleteWish(indexPath)
        }
        
        return cell
    }

}

