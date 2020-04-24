//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 27.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import Hero


// allows wish table view (and cell) to update wish list data
protocol DeleteWishDelegate {
    func deleteWish(_ idx: Int)
}

// allow MainVC to recieve updated datasource array
protocol DismissWishlistDelegate {
    func dismissWishlistVC(dataArray: [Wishlist], dropDownArray: [DropDownOption], shouldDeleteWithAnimation: Bool, indexToDelete: Int)
}

class WishlistViewController: UIViewController {

    
    let wishlistBackgroundView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "backgroundImage")
        return v
       }()
       
   let wishlistView: UIView = {
       let v = UIView()
       v.translatesAutoresizingMaskIntoConstraints = false
       v.backgroundColor = .white
       v.layer.cornerRadius = 30
       v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       return v
   }()
   
   lazy var theTableView: WhishlistTableViewController = {
      let v = WhishlistTableViewController()
       v.view.layer.masksToBounds = true
       v.view.backgroundColor = .clear
       v.view.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   let dismissWishlistViewButton: UIButton = {
       let v = UIButton()
       v.setImage(UIImage(named: "dismissButton"), for: .normal)
       v.translatesAutoresizingMaskIntoConstraints = false
       v.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
       return v
   }()
   
   let menueButton: UIButton = {
       let v = UIButton()
       v.setImage(UIImage(named: "menueButton"), for: .normal)
       v.translatesAutoresizingMaskIntoConstraints = false
       v.addTarget(self, action: #selector(menueButtonTapped), for: .touchUpInside)
       return v
   }()
   
   let wishlistLabel: UILabel = {
       let v = UILabel()
       v.text = "Wishlist"
       v.font = UIFont(name: "AvenirNext-Bold", size: 26)
       v.textAlignment = .left
       v.textColor = .white
       v.adjustsFontSizeToFitWidth = true
       v.minimumScaleFactor = 0.5
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   let wishlistImage: UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named: "iconRoundedImage")
       v.layer.shadowOpacity = 1
       v.layer.shadowOffset = CGSize(width: 1.5, height: 2.0)
       v.layer.shadowRadius = 3
       v.layer.shadowColor = UIColor.darkGray.cgColor
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
    
    let addWishButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addButtonDark"), for: .normal)
        v.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    //MARK: emptyListViews
    let emptyWishlistImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "nightSky")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let emptyWishlistLabel: UILabel = {
        let v = UILabel()
        v.text = "Du scheinst wunschlos glücklich zu sein!"
        v.font = UIFont(name: "AvenirNext-Regular", size: 15)
        v.textColor = .lightGray
        v.textAlignment = .center
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: WishView
    let transparentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    }()
    
    let wishView: WishView = {
        let v = WishView()
        v.theStackView.addBackgroundColorWithTopCornerRadius(color: .white)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var wishConstraint: NSLayoutConstraint!
    
    var wishViewIsVisible = false

    var dropOptions = [DropDownOption]()
    
    
    //MARK: CreateListView 
    let createListView: CreateNewListView = {
        let v = CreateNewListView(wishlistMode: Constants.WishlistMode.isChanging)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly
    var wishlistIDX: Int = 1
    
    // track selected wishlist in dropDownView
    var selectedWishlistIDX: Int?
    
    // create wishlist
    var wishList: Wishlist!
    
    var dataSourceArray = [Wishlist]()
    
    var dismissWishlistDelegate: DismissWishlistDelegate?
    
    var deleteListDelegate: DeleteListDelegate?
    
    // panGestureRecognizer for interactive gesture dismiss
    var panGR: UIPanGestureRecognizer!
    
    //MARK: menueTableView Variables
    public var menueOptions = [MenueOption(title: "Bearbeiten", image: UIImage(systemName: "pencil")!),
                               MenueOption(title: "Öffentlich machen", image: UIImage(systemName: "lock.open")!),
                               MenueOption(title: "Wishlist löschen", image: UIImage(systemName: "trash")!),
                               MenueOption(title: "Teilen", image: UIImage(systemName: "square.and.arrow.up")!)
                               ]
                                
    lazy var menueTableView = UITableView()
    var menueTableViewHeight: CGFloat?
    var bottomConstraint: NSLayoutConstraint?
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wishlistBackgroundView.hero.isEnabled = true
        self.wishlistBackgroundView.heroID = "wishlistView"
        self.hero.isEnabled = true
        
        self.wishView.addWishDelegate = self
        
        // adding panGestureRecognizer
        panGR = UIPanGestureRecognizer(target: self,
                  action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
        
        self.wishlistLabel.text = wishList.name
        self.wishlistImage.image = wishList.image
        self.theTableView.wishData = wishList.wishData
        self.theTableView.tableView.reloadData()
        
        setupViews()
        
        setupWishTableView()
        
        setupMenueTableView()
        
        isTableViewEmptyClosure()
        
        bottomConstraint = self.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        self.menueTableViewHeight = CGFloat(menueOptions.count * 50)
        self.menueTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 40, right: 0)
        self.menueTableView.layer.cornerRadius = 5
        self.menueTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.menueTableView.reloadData()
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    var keyboardHeight = CGFloat(0)
    
    //MARK: keyboardWillShow
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]

            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]

            if self.wishViewIsVisible {
                UIView.animate(withDuration: duration as! TimeInterval, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve as! NSNumber)), animations: {
                            self.wishConstraint.constant = -(self.wishView.frame.height + self.keyboardHeight)
                            self.view.layoutIfNeeded()
                        }, completion: nil)
            }
            
            if !self.createListView.isHidden {
                UIView.animate(withDuration: duration as! TimeInterval, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve as! NSNumber)), animations: {
                self.createListView.bottomConstraint.constant -= (self.keyboardHeight + self.createListView.bottomConstraint.constant + 10)
                self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    //MARK: setupViews
    func setupViews(){
        view.addSubview(wishlistBackgroundView)
        view.addSubview(dismissWishlistViewButton)
        view.addSubview(menueButton)
        view.addSubview(wishlistView)
        view.addSubview(wishlistLabel)
        view.addSubview(wishlistImage)
        view.addSubview(theTableView.tableView)
        view.addSubview(addWishButton)
        
        view.addSubview(self.emptyWishlistImage)
        view.addSubview(self.emptyWishlistLabel)
        
        NSLayoutConstraint.activate([
            

            // constrain wishlistView
            wishlistBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            wishlistBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wishlistBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            wishlistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160.0),
            wishlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wishlistView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            wishlistView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            // constrain wishTableView
            theTableView.view.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 40.0),
            theTableView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            theTableView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            theTableView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           
            // constrain dismissButton
            dismissWishlistViewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dismissWishlistViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            // constrain menueButton
            menueButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            menueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
            
            // constrain wishlistImage
            wishlistImage.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: -70),
            wishlistImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            wishlistImage.widthAnchor.constraint(equalToConstant: 90),
            wishlistImage.heightAnchor.constraint(equalToConstant: 90),
            
            //constrain wishlistlabel
            wishlistLabel.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: -40),
            wishlistLabel.leadingAnchor.constraint(equalTo: wishlistImage.leadingAnchor, constant: 100),
            
            addWishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addWishButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            addWishButton.widthAnchor.constraint(equalToConstant: 70),
            addWishButton.heightAnchor.constraint(equalToConstant: 70),
            
        ])
        //MARK: constrain createListView
        self.view.addSubview(self.createListView)
        
        self.createListView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.createListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.createListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.createListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.createListView.isHidden = true
        
        //MARK: constrain emptyTableView
        let screenSize = UIScreen.main.bounds.size
        
        emptyWishlistImage.centerYAnchor.constraint(equalTo: wishlistView.centerYAnchor, constant: -50).isActive = true
        emptyWishlistImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyWishlistImage.heightAnchor.constraint(equalToConstant: screenSize.height / 5).isActive = true
        emptyWishlistImage.widthAnchor.constraint(equalToConstant: screenSize.width - 60).isActive = true

        emptyWishlistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emptyWishlistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emptyWishlistLabel.topAnchor.constraint(equalTo: emptyWishlistImage.bottomAnchor, constant: 10).isActive = true
        
        emptyWishlistImage.isHidden = true
        emptyWishlistLabel.isHidden = true
        
        //MARK: constrain wishView
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        transparentView.alpha = 0
        
        self.view.addSubview(self.wishView)
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishConstraint = wishView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishConstraint.isActive = true
    }
    
    
    func isTableViewEmptyClosure(){
        // show background image and text if wishlist is empty
        self.theTableView.tableViewIsEmpty = { [unowned self] isEmpty in
            if isEmpty {
                self.emptyWishlistImage.isHidden = false
                self.emptyWishlistLabel.isHidden = false
                
            } else {
                self.emptyWishlistImage.isHidden = true
                self.emptyWishlistLabel.isHidden = true
            }
        }
    }
    
    
    //MARK: setupWishTableView
    func setupWishTableView(){
        // disable prefill tableview with cells
        let v = UIView()
        v.backgroundColor = .clear
        self.theTableView.tableView.tableFooterView = v
        
        // set DeleteWishDelegate protocol for the table
        theTableView.deleteWishDelegate = self
    }
    
    //MARK: setupMenueTableView
    func setupMenueTableView(){
        menueTableView.isScrollEnabled = true
        menueTableView.delegate = self
        menueTableView.dataSource = self
        menueTableView.register(MenueOptionCell.self, forCellReuseIdentifier: MenueOptionCell.reuseID)
    }
    
    // define a small helper function to add two CGPoints
    func addCGPoints (left: CGPoint, right: CGPoint) -> CGPoint {
      return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    // handle swqipe down gesture
    @objc private func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
      switch panGR.state {
      case .began:
        // begin the transition as normal
        self.dismissView()
        break
      case .changed:
        
        Hero.shared.update(progress)
        
      default:
        // finish or cancel the transition based on the progress and user's touch velocity
           if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
            self.dismissView()
             Hero.shared.finish()
           } else {
             Hero.shared.cancel()
           }
      }
    }
    //MARK: menueButtonTapped
    @objc private func menueButtonTapped(){
        view.removeGestureRecognizer(panGR)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        self.menueTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.menueTableViewHeight!)
        self.view.addSubview(self.menueTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenueTableView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.7
            self.menueTableView.frame = CGRect(x: 0, y: screenSize.height - self.menueTableViewHeight!, width: screenSize.width, height: self.menueTableViewHeight!)
        }, completion: nil)
    }
    
    @objc func dismissMenueTableView() {
        
        view.addGestureRecognizer(panGR)
        
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.menueTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.menueTableViewHeight!)
        }, completion: nil)
    }
    
    
    
    //MARK: dismissView
    @objc private func dismissView(){
        //  update datasource array in MainVC
        self.dismissWishlistDelegate?.dismissWishlistVC(dataArray: self.dataSourceArray, dropDownArray: self.dropOptions, shouldDeleteWithAnimation: false, indexToDelete: self.currentWishListIDX)
        
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: AddWishButton
    
    @objc func addWishButtonTapped(){
        
        view.removeGestureRecognizer(panGR)
        
        self.wishViewIsVisible = true
        
        self.view.bringSubviewToFront(self.wishView)
        
        self.wishView.imageButtonDelegate = self
        
        wishView.dropDownButton.dropView.dropOptions = self.dropOptions
        wishView.dropDownButton.dropView.tableView.reloadData()

        // set dropDownButton image and label to first wishlists image and label
        wishView.dropDownButton.listImage.image = self.dataSourceArray[self.currentWishListIDX].image
        wishView.dropDownButton.label.text = self.dataSourceArray[self.currentWishListIDX].name
        
        wishView.selectedWishlistIDX = self.selectedWishlistIDX

        // pass data array
        wishView.dataSourceArray = self.dataSourceArray
        
        wishView.wishNameTextField.becomeFirstResponder()
        wishView.disableButton()
        wishView.wishNameTextField.text = ""
        wishView.priceTextField.text = ""
        wishView.linkTextField.text = ""
        
        onImageButtonTappedClosure()
        onPriceButtonTappedClosure()
        onLinkButtonTappedClosure()
        onNoteButtonTappedClosure()
        
        transparentView.gestureRecognizers?.forEach {
            self.transparentView.removeGestureRecognizer($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissWishView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.6
        }, completion: nil)
  
    }
    
    //MARK: onImageButtonTappedClosure
    func onImageButtonTappedClosure(){
        self.wishView.onImageButtonTapped = { [unowned self] height, isHidden in

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.wishConstraint.constant += height
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    //MARK: onPriceButtonClosure
    func onPriceButtonTappedClosure(){
        self.wishView.onPriceButtonTapped = { [unowned self] height, isHidden in
            
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.priceTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    //MARK: onLinkButtonTappedClosure
    func onLinkButtonTappedClosure(){
       self.wishView.onLinkButtonTapped = { [unowned self] height, isHidden in
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.linkTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    //MARK: onNoteButtonTappedClosure
    func onNoteButtonTappedClosure(){
       self.wishView.onNoteButtonTapped = { [unowned self] height, isHidden in
            if isHidden {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant -= height
                    self.wishView.noteTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.wishConstraint.constant += height
                    self.wishView.wishNameTextField.becomeFirstResponder()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    
    @objc func dismissWishView() {
        
        view.addGestureRecognizer(panGR)
        
        self.wishViewIsVisible = false
        
        wishView.dropDownButton.dismissDropDown()
        
        self.view.layoutIfNeeded()
        
        self.wishView.endEditing(true)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.wishConstraint.constant = 0
            self.view.layoutIfNeeded()

        }) { (done) in
            self.wishView.priceView.isHidden = true
            self.wishView.linkView.isHidden = true
            self.wishView.noteView.isHidden = true
        }
        
    }
}

extension WishlistViewController: DeleteWishDelegate {
    func deleteWish(_ idx: Int){
//        // remove the wish from the user's currently selected wishlist
//        wishList.wishData.remove(at: idx)
//        // set the updated data as the data for the table view
//        theTableView.wishData = wishList.wishData
//        theTableView.tableView.beginUpdates()
//        theTableView.tableView.deleteRows(at: [
//            (NSIndexPath(row: idx, section: 0) as IndexPath)], with: .right)
//        theTableView.tableView.endUpdates()
//        // reload data so index is updated
//        theTableView.tableView.reloadData()
        print("deleted")
    }
}


extension WishlistViewController: AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?) {

        self.dataSourceArray[selectedWishlistIDX!].wishData.append(Wish(withWishName: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checked: false))
        
        // only update current list if selectedWishlist is currentWishlist
        if selectedWishlistIDX == currentWishListIDX {
            wishList.wishData.append(Wish(withWishName: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checked: false))
            theTableView.wishData = wishList.wishData
            theTableView.tableView.beginUpdates()
            theTableView.tableView.insertRows(at: [
                (NSIndexPath(row: theTableView.wishData.count-1, section: 0) as IndexPath)], with: .left)
            theTableView.tableView.endUpdates()
        }
    }
}

// MARK: ImagePickerController
extension WishlistViewController: ImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // delegate function
    func showImagePickerControllerActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // choose Alert Options
        let photoLibraryActionn = UIAlertAction(title: "Aus Album wählen", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Foto aufnehmen", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Zurück", style: .cancel, handler: nil)
        
        // Add the actions to your actionSheet
        actionSheet.addAction(photoLibraryActionn)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        // Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.wishView.set(image: editedImage)
            
            UIView.animate(withDuration: 0.25) {
                self.wishView.imageContainerView.alpha = 1
                self.wishView.imageContainerView.isHidden = false
                self.wishView.deleteImageButton.isHidden = false
                self.wishView.wishImageView.isHidden = false
                self.wishView.theStackView.layoutIfNeeded()
            }

        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            self.wishView.set(image: originalImage)
            
            UIView.animate(withDuration: 0.25) {
                self.wishView.imageContainerView.alpha = 1
                self.wishView.imageContainerView.isHidden = false
                self.wishView.deleteImageButton.isHidden = false
                self.wishView.wishImageView.isHidden = false
                self.wishView.theStackView.layoutIfNeeded()
            }

        }
        dismiss(animated: true, completion: nil)
    }
}
