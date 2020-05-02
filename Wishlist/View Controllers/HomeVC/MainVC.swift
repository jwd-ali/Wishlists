//
//  HomeViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//
 
import UIKit
import FirebaseAuth
import Firebase
    

// MARK: ViewController

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    let backGroundImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "backgroundImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.style = UIActivityIndicatorView.Style.large
        v.color = .white
        v.hidesWhenStopped = true
        return v
    }()
    
    //MARK: BottomBar
    let bottomBar: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "bottomBar")
        v.tintColor = .white
        v.image = v.image?.withRenderingMode(.alwaysTemplate)
        v.tintColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bottomRight: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bottomLeft: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bottomBottom: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let communityButton: UIButton = {
        let v = UIButton()
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .default)
        v.setImage(UIImage(systemName: "person.3.fill", withConfiguration: imageSymbolConfiguration), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(communityButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let profileButton: UIButton = {
        let v = UIButton()
        v.tintColor = UIColor.darkCustom
        v.imageView?.contentMode = .scaleAspectFit
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .default)
        v.setImage(UIImage(systemName: "person.fill", withConfiguration: imageSymbolConfiguration), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let addButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addButtonSimple"), for: .normal)
        v.imageView?.contentMode = .scaleAspectFill
        v.contentHorizontalAlignment = .fill
        v.contentVerticalAlignment = .fill
        v.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        v.isEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
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

    var dropOptions = [DropDownOption]()
   
    //MARK: CreateListView
    
    let createListView: CreateNewListView = {
        let v = CreateNewListView(wishlistMode: Constants.WishlistMode.isCreating)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: CollectionView
    let theCollectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.contentInsetAdjustmentBehavior = .always
        return v
    }()
    
    var image: UIImage?
    
    var dataSourceArray = [Wishlist]()
    
    // track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly 
    var wishlistIDX: Int = 1
    
    // track seleced Wishlist inside DropDownBtn
    var selectedWishlistIDX: Int?
    
    // only animate cells at first start
    var shouldAnimateCells = false
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // stop timer for imagePreview inside createNewListView
        self.createListView.timer?.invalidate()
        
        self.theCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        activityIndicator.startAnimating()
        
        setupViews()
        theCollectionView.isHidden = true
        DataHandler.getWishlists { (success, dataArray, dropOptionsArray)  in
            if success && dataArray != nil {
                self.shouldAnimateCells = true
                self.dataSourceArray = dataArray as! [Wishlist]
                self.theCollectionView.isHidden = false
                self.theCollectionView.reloadData()
                self.dropOptions = dropOptionsArray as! [DropDownOption]
                self.addButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                
                // save dataSourceArray in UserDefaults
                if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                    defaults.setDataSourceArray(data: dataArray as! [Wishlist])
                    defaults.synchronize()
                } else {
                    print("error Main")
                }
            }
        }
        
        // register the two cell classes for reuse
        theCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        theCollectionView.register(AddItemCell.self, forCellWithReuseIdentifier: AddItemCell.reuseID)
 
        // set collection view dataSource
        theCollectionView.dataSource = self
        
        theCollectionView.delegate = self
        
        self.view.sendSubviewToBack(theCollectionView)
        self.view.sendSubviewToBack(backGroundImage)
        
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
    
    //MARK: SetupViews
    func setupViews() {
        
        view.addSubview(backGroundImage)
        view.addSubview(activityIndicator)
        view.addSubview(theCollectionView)
        
        view.addSubview(bottomBar)
        view.addSubview(bottomRight)
        view.addSubview(bottomLeft)
        view.addSubview(bottomBottom)
        
        view.addSubview(communityButton)
        view.addSubview(profileButton)
        view.addSubview(addButton)
        
 
        NSLayoutConstraint.activate([
            
            // constrain background image
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            // constrain activity indicator
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //constrain bottomBar
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 49),
            
            bottomRight.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomRight.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomRight.heightAnchor.constraint(equalToConstant: 49),
            bottomRight.leadingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            
            bottomLeft.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLeft.heightAnchor.constraint(equalToConstant: 49),
            bottomLeft.trailingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            
            bottomBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBottom.topAnchor.constraint(equalTo: bottomBar.bottomAnchor),
            
            //contrain communityButton
            communityButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            communityButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: -view.frame.width/3.5),
            
            // constrain profileButton
            profileButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            profileButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: view.frame.width/3.5),
            
            // constrain addWishButton
            addButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -18),
            addButton.widthAnchor.constraint(equalToConstant: 70),
            addButton.heightAnchor.constraint(equalToConstant: 70),
               
            // constrain collectionView
            theCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            theCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            theCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            theCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),

        ])
        //MARK: constrain wishView
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        transparentView.alpha = 0
        
        self.view.addSubview(self.wishView)
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishConstraint = wishView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishConstraint.isActive = true
        
        //MARK: constrain createListView
        self.view.addSubview(self.createListView)
        
        self.createListView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.createListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.createListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.createListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.createListView.isHidden = true
        
    }
    
    // MARK: CreateNewListView
    func createNewListView(){
        
        createListView.isHidden = false
        createListView.wishlistNameTextField.becomeFirstResponder()
        
        for view in self.createListView.subviews as [UIView] {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        
        UIView.animate(withDuration: 0.3) {
            
            for view in self.createListView.subviews as [UIView] {
                view.alpha = 1
                view.transform = CGAffineTransform.identity
            }
       }
        
    }
    
    
    // MARK: AddWishButton
    
    var wishViewIsVisible = false
    
    @objc func addWishButtonTapped(){
        
        self.wishViewIsVisible = true
        
        self.wishView.imageButtonDelegate = self
        
        self.wishView.addWishDelegate = self
        
        wishView.dropDownButton.dropView.dropOptions = self.dropOptions
        wishView.dropDownButton.dropView.tableView.reloadData()

        // set dropDownButton image and label to first wishlists image and label
        wishView.dropDownButton.listImage.image = self.dataSourceArray[0].image
        wishView.dropDownButton.label.text = self.dataSourceArray[0].name
        
        wishView.selectedWishlistIDX = 0

        // pass data array
        wishView.dataSourceArray = self.dataSourceArray
        
        wishView.wishNameTextField.becomeFirstResponder()
        wishView.disableButton()
        wishView.wishNameTextField.text = ""
        wishView.priceTextField.text = ""
        wishView.linkTextField.text = ""
        wishView.noteTextField.text = ""
        
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

//            makeWishView.addWishDelegate = self
//
//            makeWishView.imageButtonDelegate = self
//
//            // pass data array
//            makeWishView.dataSourceArray = self.dataSourceArray
//
//            // update selectedWishlistIDX
//            makeWishView.selectedWishlistIDX = currentWishListIDX
        
        
  
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
            self.wishView.imageContainerView.isHidden = true
        }
        
    }
    
    //MARK: ProfileButton
    @objc func profileButtonTapped() {
        
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    //MARK: CommunityButton
    @objc func communityButtonTapped() {
        
        let communityView = self.storyboard?.instantiateViewController(withIdentifier: "CommunityVC") as! CommunityViewController

        self.navigationController?.pushViewController(communityView, animated: true)

    }
    
    
    
}



//MARK: DelegateExtensions

extension MainViewController: CreateListDelegate {
    
    func createListTappedDelegate(listImage: UIImage, listImageIndex: Int, listName: String) {
        
        self.shouldAnimateCells = true
        
        // append created list to data source array
        var textColor = UIColor.white
        if Constants.Wishlist.darkTextColorIndexes.contains(listImageIndex) {
            textColor = UIColor.darkGray
        }
        
        DataHandler.getListCounter { (success, listCounter) in
            let newIndex = listCounter as! Int + 1
            
            self.dataSourceArray.append(Wishlist(name: listName, image: listImage, wishes: [Wish](), color: Constants.Wishlist.customColors[listImageIndex], textColor: textColor, index: newIndex))
            
             // append created list to drop down options
             self.dropOptions.append(DropDownOption(name: listName, image: listImage))
             
             // reload the collection view
            self.theCollectionView.reloadData()
            self.theCollectionView.performBatchUpdates(nil, completion: {
                 (result) in
                 // scroll to make newly added row visible (if needed)
                 let i = self.theCollectionView.numberOfItems(inSection: 0) - 1
                 let idx = IndexPath(item: i, section: 0)
                 self.theCollectionView.scrollToItem(at: idx, at: .bottom, animated: true)
                 
             })
        }
    }
}

// allow MainVC to recieve updated datasource array
extension MainViewController: DismissWishlistDelegate {
    
    func dismissWishlistVC(dataArray: [Wishlist], dropDownArray: [DropDownOption], shouldDeleteWithAnimation: Bool, indexToDelete: Int) {

        if shouldDeleteWithAnimation {

            self.shouldAnimateCells = true
            self.dataSourceArray.remove(at: self.currentWishListIDX)
            self.dropOptions.remove(at: self.currentWishListIDX)

            // reload the collection view
            theCollectionView.reloadData()
            

        } else {

            self.shouldAnimateCells = false
            self.dataSourceArray = dataArray
            self.dropOptions = dropDownArray

            // reload the collection view
            theCollectionView.reloadData()
            theCollectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}

extension MainViewController: SelectedWishlistProtocol{
    func didSelectWishlist(idx: Int) {
        self.selectedWishlistIDX = idx
    }
}

//extension MainViewController: DeleteWishDelegate {
//    func deleteWish(_ idx: Int){
//        // remove the wish from the user's currently selected wishlist
//        wishList.wishData.remove(at: idx)
//        // set the updated data as the data for the table view
//        theTableView.wishList = wishList.wishData
//        theTableView.tableView.beginUpdates()
//        theTableView.tableView.deleteRows(at: [
//            (NSIndexPath(row: idx, section: 0) as IndexPath)], with: .right)
//        theTableView.tableView.endUpdates()
//        // reload data so index is updated
//        theTableView.tableView.reloadData()
//    }
//}


extension MainViewController: AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?, wishImage: UIImage?, wishLink: String?, wishPrice: String?, wishNote: String?) {
        
        self.dataSourceArray[selectedWishlistIDX!].wishes.append(Wish(name: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checkedStatus: false))
        
        self.dismissWishView()
        
    }
}

// MARK: ImagePickerController
extension MainViewController: ImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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






