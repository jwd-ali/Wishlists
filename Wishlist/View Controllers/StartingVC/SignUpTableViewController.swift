//
//  SignUpTableViewTableViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 27.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit
import TransitionButton

class SignUpTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        // disable didSelectAt
        self.tableView.allowsSelection = false
        
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = 90
        
        // register all cells for tableView
        self.tableView.register(SignUpEmailCell.self, forCellReuseIdentifier: SignUpEmailCell.reuseID)
        self.tableView.register(SignUpHandleCell.self, forCellReuseIdentifier: SignUpHandleCell.reuseID)
        self.tableView.register(SignUpAnzeigeName.self, forCellReuseIdentifier: SignUpAnzeigeName.reuseID)
        self.tableView.register(SignUpPasswordCell.self, forCellReuseIdentifier: SignUpPasswordCell.reuseID)
        self.tableView.register(SignUpPasswordRepeatCell.self, forCellReuseIdentifier: SignUpPasswordRepeatCell.reuseID)
        self.tableView.register(SignUpDocumentCell.self, forCellReuseIdentifier: SignUpDocumentCell.reuseID)
        self.tableView.register(SignUpButtonCell.self, forCellReuseIdentifier: SignUpButtonCell.reuseID)
        
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1st cell -> email textfield
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpEmailCell", for: indexPath) as! SignUpEmailCell
            return cell
        // 2nd cell -> anzeigename
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpAnzeigeName", for: indexPath) as! SignUpAnzeigeName
            return cell
        // 3rd cell -> Wishlist-Handle
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpHandleCell", for: indexPath) as! SignUpHandleCell
            return cell
        // 4th cell -> passwort textfield
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpPasswordCell", for: indexPath) as! SignUpPasswordCell
            return cell
        // 5th cell -> repeat password textfield
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpPasswordRepeatCell", for: indexPath) as! SignUpPasswordRepeatCell
            return cell
        // 6th cell -> document label
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpDocumentCell", for: indexPath) as! SignUpDocumentCell
            return cell
        }
        // last cell -> signUpButton
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpButtonCell", for: indexPath) as! SignUpButtonCell
        return cell
    }

}
