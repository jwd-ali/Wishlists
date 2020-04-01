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
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    // MARK: MakeWishView
    
    let makeWishView: MakeWishView = {
        let v = MakeWishView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

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
    
    
    // MARK: CollectionView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // only want to call this when collection view frame changes
        // to set the item size
        if theCollectionView.frame.width != colViewWidth {
            let w = theCollectionView.frame.width
            columnLayout.itemSize = CGSize(width: w, height: 160)
            colViewWidth = theCollectionView.frame.width
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 1 more than our data array (the extra one will be the "add item" cell)
        return dataSourceArray.count + 1
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // if indexPath.item is less than data count, return a "Content" cell
        if indexPath.item < dataSourceArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
            // set cell label
            cell.cellLabel.text = dataSourceArray[indexPath.item].name
            // set cell image
            cell.wishlistImage.image = dataSourceArray[indexPath.item].image

            cell.priceLabel.textColor = dataSourceArray[indexPath.item].textColor
            cell.priceEuroLabel.textColor = dataSourceArray[indexPath.item].textColor
            cell.wishCounterLabel.textColor = dataSourceArray[indexPath.item].textColor
            cell.wünscheLabel.textColor = dataSourceArray[indexPath.item].textColor

            // set background color
            cell.imageView.backgroundColor = dataSourceArray[indexPath.item].color
            cell.wishCounterView.backgroundColor = dataSourceArray[indexPath.item].color
            cell.priceView.backgroundColor = dataSourceArray[indexPath.item].color
            
            let heroID = "wishlistImageIDX\(indexPath.item)"
            cell.wishlistImage.heroID = heroID
            
            let addButtonHeroID = "addWishButtonID"
            self.addButton.heroID = addButtonHeroID
            
            cell.customWishlistTapCallback = {
                // track selected index
                self.currentWishListIDX = indexPath.item
                    
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistViewController
                
                vc.wishList = self.dataSourceArray[indexPath.item]
                // pass drop down options
                vc.dropOptions = self.dropOptions
                // pass current wishlist index
                vc.currentWishListIDX = indexPath.item
                // pass the data array
                vc.dataSourceArray = self.dataSourceArray
                // set Hero ID for transition
                vc.wishlistImage.heroID = heroID
                vc.addWishButton.heroID = addButtonHeroID
                // allow MainVC to recieve updated datasource array
                vc.dismissWishlistDelegate = self
                    
                vc.theTableView.tableView.reloadData()
                self.present(vc, animated: true, completion: nil)
                
            }
            
            return cell
        }
        
        // past the end of the data count, so return an "Add Item" cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemCell.reuseID, for: indexPath) as! AddItemCell

        //MARK: addList-Cell-Tapped
        // set the closure
        cell.tapCallback = {
            
            self.createNewListView()
            // reset textfield
            self.createListView.wishlistNameTextField.text = ""
            self.createListView.wishlistNameTextField.becomeFirstResponder()
            // disable button
            self.createListView.disableButton()
            // start timer for imagePreview
            self.createListView.startImagePreviewAnimation()
            // set delegate
            self.createListView.createListDelegate = self
            
        }
        
        return cell
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.shouldAnimateCells = false
    }
    
    // animate displaying cells
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(self.shouldAnimateCells){
             // add animations here
            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.1)
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: collectionView)
        }
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
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: AddWishButton
    
    @objc func addWishButtonTapped(){
        
        view.addSubview(makeWishView)
            
            makeWishView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            makeWishView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            makeWishView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            makeWishView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            makeWishView.grayView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
            makeWishView.visualEffectView.alpha = 0
            makeWishView.grayView.alpha = 0
            makeWishView.wishButton.alpha = 0
            makeWishView.closeButton.alpha = 0
            makeWishView.dropDownButton.alpha = 0
            makeWishView.wishNameTextField.alpha = 0
            makeWishView.wishImageView.alpha = 0
            makeWishView.wishImageButton.alpha = 0
            makeWishView.linkTextField.alpha = 0
            makeWishView.priceTextField.alpha = 0
            makeWishView.noteTextField.alpha = 0
            makeWishView.linkImage.alpha = 0
            makeWishView.priceImage.alpha = 0
            makeWishView.noteImage.alpha = 0
            
            makeWishView.addWishDelegate = self
            
            makeWishView.imageButtonDelegate = self
            
            // set dropDownOptions
            makeWishView.dropDownButton.dropView.dropOptions = self.dropOptions
            
            // set dropDownButton image and label to first wishlists image and label
            makeWishView.dropDownButton.listImage.image = self.dataSourceArray[0].image
            makeWishView.dropDownButton.label.text = self.dataSourceArray[0].name
            
            // pass data array
            makeWishView.dataSourceArray = self.dataSourceArray
            
            // update selectedWishlistIDX
            makeWishView.selectedWishlistIDX = currentWishListIDX
            
            // reset textfield
            makeWishView.wishNameTextField.text = ""
            // hide wishButton
            makeWishView.wishButton.isHidden = true
            makeWishView.wishButtonDisabled.isHidden = false
            
            makeWishView.wishNameTextField.becomeFirstResponder()
                
            UIView.animate(withDuration: 0.3) {
                
                self.makeWishView.visualEffectView.alpha = 1
                self.makeWishView.grayView.alpha = 1
                self.makeWishView.wishButton.alpha = 1
                self.makeWishView.closeButton.alpha = 1
                self.makeWishView.dropDownButton.alpha = 1
                self.makeWishView.wishNameTextField.alpha = 1
                self.makeWishView.wishImageView.alpha = 1
                self.makeWishView.wishImageButton.alpha = 1
                self.makeWishView.linkTextField.alpha = 1
                self.makeWishView.priceTextField.alpha = 1
                self.makeWishView.noteTextField.alpha = 1
                self.makeWishView.linkImage.alpha = 1
                self.makeWishView.priceImage.alpha = 1
                self.makeWishView.noteImage.alpha = 1
                
                self.makeWishView.grayView.transform = CGAffineTransform.identity
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






