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
    
    //MARK: BottomBar
    let bottomBar: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "bottomBar")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let communityButton: UIButton = {
        let v = UIButton()
        if #available(iOS 13.0, *) {
            v.setImage(UIImage(named: "achievements"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(communityButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let profileButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "profile"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let addButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addButtonDark"), for: .normal)
        v.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        v.isEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    // MARK: MakeWishView
    
    let makeWishView: MakeWishView = {
        let v = MakeWishView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var transparentView =  UIView()
    
    let wishView: WishView = {
        let v = WishView()
        v.theStackView.addBackgroundColorWithTopCornerRadius(color: .darkCustom)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var wishWishConstraint: NSLayoutConstraint!

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
 
    let columnLayout = FlowLayout(
        itemSize: CGSize(width: 150, height: 150),
        minimumInteritemSpacing: 20,
        minimumLineSpacing: 13,
        sectionInset: UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    )
 
    // track collection view frame change
    var colViewWidth: CGFloat = 0.0
    
    var image: UIImage?
    
    var dataSourceArray = [Wishlist]()
    
    // DonMag3 - track the current selected wish list
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
        
        // setting dropDownTableView color only works here
        wishView.dropDownButton.dropView.tableView.backgroundColor = .clear
        
        // stop timer for imagePreview inside createNewListView
        self.createListView.timer?.invalidate()
        
        self.theCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
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
            }
        }
        
        // register the two cell classes for reuse
        theCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseID)
        theCollectionView.register(AddItemCell.self, forCellWithReuseIdentifier: AddItemCell.reuseID)
 
        // set collection view dataSource
        theCollectionView.dataSource = self
        
        theCollectionView.delegate = self
 
        // use custom flow layout
        theCollectionView.collectionViewLayout = columnLayout
        
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
        }
    }
    
    //MARK: SetupViews
    func setupViews() {
        
        view.addSubview(backGroundImage)
        view.addSubview(theCollectionView)
        view.addSubview(bottomBar)
        view.addSubview(communityButton)
        view.addSubview(profileButton)
        view.addSubview(addButton)
        
 
        NSLayoutConstraint.activate([
            
            // constrain background image
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            //constrain bottomBar
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            //contrain communityButton
            communityButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -5),
            communityButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: -view.frame.width/3.5),
            communityButton.widthAnchor.constraint(equalToConstant: 50),
            communityButton.heightAnchor.constraint(equalToConstant: 50),
            
            // constrain profileButton
            profileButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -5),
            profileButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: view.frame.width/3.5),
            profileButton.widthAnchor.constraint(equalToConstant: 50),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // constrain addWishButton
            addButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -40),
               
            // constrain collectionView
            theCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            theCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            theCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            theCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),

        ])
    }
    
    // MARK: CreateNewListView
    func createNewListView(){
        self.view.addSubview(self.createListView)
        
        self.createListView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.createListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.createListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.createListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.createListView.imagePreview.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.createListView.wishlistNameTextField.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.createListView.createButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.createListView.closeButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.createListView.editButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.createListView.visualEffectView.alpha = 0
        self.createListView.imagePreview.alpha = 0
        self.createListView.editButton.alpha = 0
        self.createListView.closeButton.alpha = 0
        self.createListView.wishlistNameTextField.alpha = 0
        self.createListView.createButton.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
                       
            self.createListView.visualEffectView.alpha = 1
            self.createListView.imagePreview.alpha = 1
            self.createListView.editButton.alpha = 1
            self.createListView.closeButton.alpha = 1
            self.createListView.wishlistNameTextField.alpha = 1
            self.createListView.createButton.alpha = 1
           
            self.createListView.imagePreview.transform = CGAffineTransform.identity
            self.createListView.wishlistNameTextField.transform = CGAffineTransform.identity
            self.createListView.createButton.transform = CGAffineTransform.identity
            self.createListView.editButton.transform = CGAffineTransform.identity
            self.createListView.closeButton.transform = CGAffineTransform.identity
       }
    }
    
    
    // MARK: AddWishButton
    
    @objc func addWishButtonTapped(){
        
        wishView.dropDownButton.dropView.dropOptions = self.dropOptions

        // set dropDownButton image and label to first wishlists image and label
        wishView.dropDownButton.listImage.image = self.dataSourceArray[0].image
        wishView.dropDownButton.label.text = self.dataSourceArray[0].name

        // pass data array
        wishView.dataSourceArray = self.dataSourceArray
        
        wishView.wishNameTextField.becomeFirstResponder()
        wishView.disableButton()
        wishView.wishNameTextField.text = ""
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
            
//        let screenSize = UIScreen.main.bounds.size
//        self.wishView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.wishView.height)
        
        self.view.addSubview(self.wishView)
        
        self.wishView.onPriceButtonTapped = { [unowned self] height in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.wishWishConstraint.constant -= height
                self.view.layoutIfNeeded()
            }
        }
        
        wishView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        wishView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        wishWishConstraint = wishView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        wishWishConstraint.isActive = true
        
        transparentView.gestureRecognizers?.forEach {
            self.transparentView.removeGestureRecognizer($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissWishWishView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.7
//            self.wishView.frame = CGRect(x: 0, y: screenSize.height - self.wishView.height - self.keyboardHeight, width: screenSize.width, height: self.wishView.height)
            self.wishWishConstraint.constant = -(self.wishView.frame.height + self.keyboardHeight)
            self.view.layoutIfNeeded()
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
    
    
    @objc func dismissWishWishView() {
        
        wishView.dropDownButton.dismissDropDown()
       
//        let screenSize = UIScreen.main.bounds.size
        
        self.view.layoutIfNeeded()
        
        self.wishView.endEditing(true)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
//            self.wishView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.wishView.height)
            self.wishWishConstraint.constant = 0
            self.view.layoutIfNeeded()

        }) { (done) in
            self.transparentView.removeFromSuperview()
            self.wishView.removeFromSuperview()
            self.wishView.priceView.isHidden = true
        }
        
    }
    
    //MARK: ProfileButton
    @objc func profileButtonTapped() {
        
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    //MARK: CommunityButton
    @objc func communityButtonTapped() {
        
//        let communityView = self.storyboard?.instantiateViewController(withIdentifier: "CommunityVC") as! CommunityViewController
//
//        self.navigationController?.pushViewController(communityView, animated: true)
        self.theCollectionView.reloadData()
        

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
            
            self.dataSourceArray.append(Wishlist(name: listName, image: listImage, wishData: [Wish](), color: Constants.Wishlist.customColors[listImageIndex], textColor: textColor, index: newIndex))
            
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
        
        self.makeWishView.dropDownButton.dropView.tableView.reloadData()
        
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
        self.dataSourceArray[selectedWishlistIDX!].wishData.append(Wish(withWishName: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checked: false))
        
//        // only update current list if selectedWishlist is currentWishlist
//        if selectedWishlistIDX == currentWishListIDX {
//            wishList.wishData.append(Wish(withWishName: wishName!, link: wishLink!, price: wishPrice!, note: wishNote!, image: wishImage!, checked: false))
//            theTableView.wishList = wishList.wishData
//            theTableView.tableView.beginUpdates()
//            theTableView.tableView.insertRows(at: [
//                (NSIndexPath(row: theTableView.wishList.count-1, section: 0) as IndexPath)], with: .left)
//            theTableView.tableView.endUpdates()
//        }
    }
}

// MARK: ImagePickerController
extension MainViewController: ImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // delegate function
    func showImagePickerControllerActionSheet() {
        // choose Alert Options
        let photoLibraryActionn = UIAlertAction(title: "Aus Album wählen", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Foto aufnehmen", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Zurück", style: .cancel, handler: nil)
        
        
        AlertService.showAlert(style: .actionSheet, title: "Wähle ein Bild aus", message: nil, actions: [photoLibraryActionn, cameraAction, cancelAction], completion: nil)
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
            makeWishView.wishImageView.image = editedImage
            makeWishView.wishImageButton.titleLabel?.text = ""
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            makeWishView.wishImageButton.titleLabel?.text = ""
            makeWishView.wishImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}






