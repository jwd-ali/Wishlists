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
    
//    public var wishDataTest = [Wish]()
    
    var tableViewIsEmpty: ((Bool) -> Void)?

    // protocol / delegate pattern
    public var deleteWishDelegate: DeleteWishDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        wishDataTest.append(Wish(name: "yeet", link: "", price: "", note: "", image: UIImage(named: "testImageShoes-1")!, checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "2344", note: "asdf", image: UIImage(named: "testImageShoes-1")!, checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "2344", note: "asdf", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "", note: "asdf", image: UIImage(named: "testImageShoes-1")!, checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "2344", note: "", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "", note: "", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "2344", note: "", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "", note: "asdf", image: UIImage(named: "testImageShoes-1")!, checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "2344", note: "asdf", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "2344", note: "asdf", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "", note: "asdf", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "2344", note: "", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "adidas.com", price: "", note: "", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "2344", note: "", image: UIImage(named: "testImageShoes-1")!, checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "", note: "asdf", image: UIImage(), checkedStatus: false))
//        wishDataTest.append(Wish(name: "yeet", link: "", price: "", note: "", image: UIImage(), checkedStatus: false))
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: WhishCell.reuseID, for: indexPath) as! WhishCell
        
        let currentWish = self.wishData[indexPath.row]
        
        cell.label.text = currentWish.name
        
        if currentWish.link.isEmpty {
            cell.linkLabel.text = "Link hinzugügen"
        }  else {
            cell.linkLabel.text = "Link öffnen"
        }
        cell.priceLabel.text = currentWish.price
        cell.noteLabel.text = currentWish.note
        cell.wishImage.image = currentWish.image
        
        cell.setupSuccessAnimation()
        
        cell.noteView.isHidden = false
        cell.priceView.isHidden = false
        cell.linkView.isHidden = false
        cell.imageContainerView.isHidden = false
        cell.secondaryStackViewHeightConstraint.constant = 0
        cell.thirdHelperViewHeightConstraint.constant = 0
        
        if currentWish.image == nil || !currentWish.image!.hasContent {
            cell.imageContainerView.isHidden = true
            if currentWish.price != "" {
                cell.thirdHelperViewHeightConstraint.constant += 30
                cell.secondaryStackViewHeightConstraint.constant += 30
            }
            if currentWish.link != "" {
                cell.thirdHelperViewHeightConstraint.constant += 30
                cell.secondaryStackViewHeightConstraint.constant += 30
            }
            if currentWish.note != "" {
                cell.thirdHelperViewHeightConstraint.constant += 30
                cell.secondaryStackViewHeightConstraint.constant += 30
            }
        } else {
            cell.secondaryStackViewHeightConstraint.constant = 90
            cell.thirdHelperViewHeightConstraint.constant = 90
        }
        
        if currentWish.price == "" {
            cell.priceView.isHidden = true
        }
        
        if currentWish.link == "" {
            cell.linkView.isHidden = true
        }
        
        if currentWish.note == "" {
            cell.noteView.isHidden = true
        }
            
        // tapping the checkbox in the wish cell will call back here
        // and we tell the delegate to delete the wish
        cell.deleteWishCallback = {
            self.deleteWishDelegate?.deleteWish(indexPath)
        }
        
        return cell
    }

}

