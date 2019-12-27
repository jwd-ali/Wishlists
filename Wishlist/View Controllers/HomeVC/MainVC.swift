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
// DonMag3 - conform to DeleteWishDelegate protocol
class MainViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var welcomeTextLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var listNameTextfield: UITextField!
    @IBOutlet weak var blurrImage: UIImageView!
    @IBOutlet weak var newListView: UIView!
    @IBOutlet weak var newListTextfield: UITextField!
    @IBOutlet weak var createListButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    let searchButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "searchButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v

    }()
    
    let welcomeLabel: UILabel = {
        let v = UILabel()
        v.text = ""
        v.font = UIFont(name: "AvenirNext-Bold", size: 53)
        v.textColor = .white
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
    
    let achievementsButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "achievements"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profileButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "profile"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let addButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addButton"), for: .normal)
        v.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
//    // MARK: WishListView
//
//    let wishlistBackgroundView: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .darkGray
//        return v
//    }()
//
//    let wishlistView: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .gray
//        v.layer.cornerRadius = 30
//        return v
//    }()
//
//    lazy var theTableView: WhishlistTableViewController = {
//       let v = WhishlistTableViewController()
//        v.view.layer.masksToBounds = true
//        v.view.layer.borderColor = UIColor.white.cgColor
//        v.view.backgroundColor = .clear
//        v.view.layer.borderWidth = 7.0
//        v.view.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//
//    let dismissWishlistViewButton: UIButton = {
//        let v = UIButton()
//        v.setImage(UIImage(named: "dismissButton"), for: .normal)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.addTarget(self, action: #selector(hideView), for: .touchUpInside)
//        return v
//    }()
//
//    let menueButton: UIButton = {
//        let v = UIButton()
//        v.setImage(UIImage(named: "menueButton"), for: .normal)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.addTarget(self, action: #selector(menueButtonTapped), for: .touchUpInside)
//        return v
//    }()
//
//    let wishlistLabel: UILabel = {
//        let v = UILabel()
//        v.text = "Main Wishlist"
//        v.font = UIFont(name: "AvenirNext-Bold", size: 30)
//        v.textColor = .white
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//
//    let wishlistImage: UIImageView = {
//        let v = UIImageView()
//        v.image = UIImage(named: "iconRoundedImage")
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
    
    
    // MARK: PopUpView
    
    let helperView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let popUpView: PopUpView = {
        let v = PopUpView()
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "wishButton"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(wishButtonTapped), for: .touchUpInside)
        v.contentVerticalAlignment = .fill
        v.contentHorizontalAlignment = .fill
        return v
    }()
    
    let closeButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "closeButtonWhite"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        return v
    }()
    
    var dropDownButton = DropDownBtn()
    
    let visualEffectView: UIVisualEffectView = {
        let blurrEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurrEffect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    
    // MARK: CollectionView
   
    let theCollectionView: UICollectionView = {
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 225/255.0, green: 215/255.0, blue: 200/255.0, alpha: 1)
        v.contentInsetAdjustmentBehavior = .always
        v.layer.cornerRadius = 30
        return v
    }()
 
    let columnLayout = FlowLayout(
        itemSize: CGSize(width: 150, height: 150),
        minimumInteritemSpacing: 20,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    )
 
    // track collection view frame change
    var colViewWidth: CGFloat = 0.0
 
    // collectionView data, Image + Label
    var wishListTitlesArray: [String] = [String]()
    var wishListImagesArray: [UIImage] = [UIImage]()
    
    var image: UIImage?
   
    func styleTextField(_ textfield:UITextField) {
    }
    
    private let imageView = UIImageView()
    private var imageTimer: Timer?
    
    let images: [UIImage] = [
        UIImage(named: "avocadoImage")!,
        UIImage(named: "beerImage")!,
        UIImage(named: "bikeImage")!,
        UIImage(named: "christmasImage")!,
        UIImage(named: "dressImage")!,
        UIImage(named: "giftImage")!,
        UIImage(named: "goalImage")!,
        UIImage(named: "rollerImage")!,
        UIImage(named: "shirtImage")!,
        UIImage(named: "shoeImage")!,
        UIImage(named: "travelImage")!,
    ]
    
    // array of wish lists
    // this will eventually be managed by some type of data handler class
    var userWishListData: [[Wish]] = [[Wish]]()
    
    // DonMag3 - track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly 
    var wishlistIDX: Int = 1
    
    var selectedWishlistIDX: Int?
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the dropDownButton
        dropDownButton = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownButton.dropView.selectedWishlistDelegate = self
        dropDownButton.setTitle("Liste wählen", for: .normal)
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        
        // configure image in createNewListPopUpView
        imagePreview.image = UIImage(named: "iconRoundedImage")
        image = UIImage(named: "iconRoundedImage")
        
        // set up popUpView
        self.createListButton.layer.cornerRadius = 2
        self.listNameTextfield.tintColor = .lightGray
        self.listNameTextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.5)
        self.blurrImage.transform = CGAffineTransform(translationX: 0, y: 1000)
        self.newListView.transform = CGAffineTransform(translationX: 0, y: 1000)
        
        // hide welcomeLabel
        self.welcomeLabel.transform = CGAffineTransform(translationX: -270, y: 0)
       
        // set CollectionView to bottom
        self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 500)
        
        self.theCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
       
        // animate collectionView
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // retrieve firstname from DB and animate welcomeLabel
        setupWelcomeLabel()
        
//        // hide wishlistView
//        self.wishlistView.transform = CGAffineTransform(translationX: 0, y: 1000)
//        self.wishlistBackgroundView.transform = CGAffineTransform(translationX: 0, y: 1000)
        
//        // add slideDown-gesture to WishlistView
//        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
//        slideDown.direction = .down
//        view.addGestureRecognizer(slideDown)
        
//        // adding notification from `ContainerViewController` so `addButtonTapped` is accessable here
//        NotificationCenter.default.addObserver(self, selector: #selector(self.addWishButtonTapped(notification:)), name: Notification.Name("addWishButtonTapped"), object: nil)

        // MARK: Views + Constraints
        view.addSubview(theCollectionView)
//        view.addSubview(wishlistView)
        view.addSubview(welcomeLabel)
        view.addSubview(searchButton)
        view.addSubview(bottomBar)
        view.addSubview(achievementsButton)
        view.addSubview(profileButton)
        view.addSubview(addButton)
        
//        view.addSubview(wishlistBackgroundView)
//        wishlistBackgroundView.addSubview(wishlistView)
//        wishlistView.addSubview(dismissWishlistViewButton)
//        wishlistView.addSubview(menueButton)
//        wishlistView.addSubview(wishlistLabel)
//        wishlistView.addSubview(wishlistImage)
//        wishlistView.addSubview(theTableView.tableView)
//
//        addChild(theTableView)
 
        NSLayoutConstraint.activate([
            
            //constrain bottomBar
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            //contrain achievementsButton
            achievementsButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -5),
            achievementsButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: -view.frame.width/3.5),
            achievementsButton.widthAnchor.constraint(equalToConstant: 70),
            achievementsButton.heightAnchor.constraint(equalToConstant: 70),
            
            // constrain profileButton
            profileButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -5),
            profileButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: view.frame.width/3.5),
            profileButton.widthAnchor.constraint(equalToConstant: 70),
            profileButton.heightAnchor.constraint(equalToConstant: 70),
            
            // constrain addWishButton
            addButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -40),
            
               
            // constrain collectionView
            theCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
            theCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            theCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
            
            //constrain welcomeLabel
            welcomeLabel.topAnchor.constraint(equalTo: theCollectionView.topAnchor, constant: -65),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            
            // constrain searchButton
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            
            
        ])
        
        // register the two cell classes for reuse
        theCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
        theCollectionView.register(AddItemCell.self, forCellWithReuseIdentifier: "AddItemCell")
        theCollectionView.register(MainWishlistCell.self, forCellWithReuseIdentifier: "MainWishlistCell")
 
        // set collection view dataSource
        theCollectionView.dataSource = self
 
        // use custom flow layout
        theCollectionView.collectionViewLayout = columnLayout
        
        // add observer to starte/stop timer for imagePreview-rotation
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackgroundHandler), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundHandler), name: UIApplication.willEnterForegroundNotification, object: nil)
        
//        self.view.sendSubviewToBack(wishlistView)
//        self.view.sendSubviewToBack(wishlistBackgroundView)
        self.view.sendSubviewToBack(welcomeLabel)
        self.view.sendSubviewToBack(theCollectionView)
        self.view.sendSubviewToBack(backGroundImage)
        
        
//        // set DeleteWishDelegate protocol for the table
//        theTableView.deleteWishDelegate = self
        
        // hide collection view while data is retirieved from server
        theCollectionView.isHidden = true

        // get the data from the server
        retrieveUserDataFromDB()
    }

    
    
    // MARK: ImageRotation-Functions
    @objc private func appDidEnterBackgroundHandler() {

        if imageTimer != nil {
            imageTimer!.invalidate()
            imageTimer = nil
        }
    }

    @objc private func appWillEnterForegroundHandler() {
        startImageTimer()
    }
    
    private func startImageTimer() {
        // instantiate timer
        imageTimer = Timer(fire: Date(), interval: 1.8, repeats: true) { (timer) in
            UIView.transition(with: self.imagePreview,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                var imageStore = self.images.randomElement()
                if (imageStore == self.imagePreview){
                    imageStore = self.images.randomElement()
                }
                self.imagePreview.image = imageStore
                self.image = imageStore
                
                // keep track of currentImageArraIDX
                self.currentImageArrayIDX = self.images.firstIndex(where: {$0 == imageStore})
            },
            completion: nil)
        }
        // add to run loop
        RunLoop.main.add(imageTimer!, forMode: .common)

    }
    
    // MARK: CollectionView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    // change "sender: Any" to "sender: Any?" so we can call this
    // from "Liste erstellen" button tap
    @IBAction func closeButtonTappedNewList(_ sender: Any?) {
        
        self.appDidEnterBackgroundHandler()
        
        self.newListTextfield.resignFirstResponder()
        self.listNameTextfield.text = ""
        
        // let newListView disappear
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.blurrImage.transform = CGAffineTransform(translationX: 0, y: 1000)
            self.newListView.transform = CGAffineTransform(translationX: 0, y: 1000)
            self.view.layoutIfNeeded()
        })

    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        // only want to call this when collection view frame changes
        // to set the item size
        if theCollectionView.frame.width != colViewWidth {
            let w = theCollectionView.frame.width / 2 - 30
            columnLayout.itemSize = CGSize(width: w, height: w + 50)
            colViewWidth = theCollectionView.frame.width
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 1 more than our data array (the extra one will be the "add item" cell)
        return wishListTitlesArray.count + 1
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // if indexPath.item is less than data count, return a "Content" cell
        if indexPath.item < wishListTitlesArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            cell.cellLabel.text = wishListTitlesArray[indexPath.item]
            
            cell.buttonView.setImage(wishListImagesArray[indexPath.item], for: .normal)
            
            cell.customWishlistTapCallback = {
            
                // track selected index
                self.currentWishListIDX = indexPath.item
                    
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistViewController
                // set image
                vc.wishlistImage.image = self.wishListImagesArray[indexPath.item]
                // set label
                vc.wishlistLabel.text = self.wishListTitlesArray[indexPath.item]
                // set wishlist
                vc.theTableView.wishList = self.userWishListData[indexPath.item]
                
                vc.currentWishListIDX = self.currentWishListIDX
                
                vc.userWishListData = self.userWishListData
                    
                vc.theTableView.tableView.reloadData()
                self.present(vc, animated: true, completion: nil)
                
            }
            
            return cell
        }
        
        // past the end of the data count, so return an "Add Item" cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
        
        // set the closure
        cell.tapCallback = {
            
            self.listNameTextfield.becomeFirstResponder()
            
            // let newListView appear
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.blurrImage.alpha = 0.96
                self.blurrImage.transform = CGAffineTransform(translationX: 0, y: 0)
                self.newListView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.layoutIfNeeded()
            })
            
            self.appWillEnterForegroundHandler()
            
        }
        
        return cell
        
    }
    
    // MARK: CreateNewListView
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
 
    @IBAction func createListButtonTapped(_ sender: Any) {
        
       
        // "Liste erstellen" button was tapped
        self.appDidEnterBackgroundHandler()
                   
        // save list to databse -> DataHandler
        self.saveWishlist()
       
        if let txt = listNameTextfield.text {
            
            self.newListTextfield.resignFirstResponder()
           
            // append user-entered text to the data array
            self.wishListTitlesArray.append(txt)
            self.wishListImagesArray.append(self.image!)
            self.dropDownButton.dropView.dropDownOptions.append(txt)
            self.dropDownButton.dropView.dropDownListImages.append(self.image!)
            self.dropDownButton.dropView.tableView.reloadData()
            
            // DonMag3 - append new empty wish array
            self.userWishListData.append([Wish]())
            
            // reload the collection view
            theCollectionView.reloadData()
            theCollectionView.performBatchUpdates(nil, completion: {
                (result) in
                // scroll to make newly added row visible (if needed)
                let i = self.theCollectionView.numberOfItems(inSection: 0) - 1
                let idx = IndexPath(item: i, section: 0)
                self.theCollectionView.scrollToItem(at: idx, at: .bottom, animated: true)
               
                // close (hide) the "New List" view
                self.closeButtonTappedNewList(nil)
                
            })
        }
    }
    @IBAction func editButtonTapped(_ sender: Any) {
        let imageCollectionView = self.storyboard?.instantiateViewController(withIdentifier: "ImageCollectionVC") as! ImageCollectionViewController
        imageCollectionView.delegate = self
        if (self.navigationController == nil){
            print("fuck")
        }
        self.navigationController?.present(imageCollectionView, animated: true)
    }
    
    // MARK: wishPopUpView
    
    @objc func closePopUp(){
        dismissPopUpView()
    }
    
    @objc func addWishButtonTapped(){
        
        popUpView.popUpTextField.text = ""
        self.popUpView.popUpTextField.becomeFirstResponder()
        
        view.addSubview(visualEffectView)
        view.addSubview(helperView)
        view.addSubview(popUpView)
        view.addSubview(wishButton)
        view.addSubview(closeButton)
        view.addSubview(dropDownButton)
        
        
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // constrain invisible helperView
        helperView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        helperView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        helperView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        helperView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // constrain popUpView
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        popUpView.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
        
        // constrain wishButton
        wishButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        wishButton.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor, constant: 70).isActive = true
        wishButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        // constrain dropDownbutton
        dropDownButton.centerXAnchor.constraint(equalTo: self.popUpView.centerXAnchor).isActive = true
        dropDownButton.centerYAnchor.constraint(equalTo: self.popUpView.centerYAnchor).isActive = true
        dropDownButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dropDownButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // constrain closeButton
        closeButton.leftAnchor.constraint(equalTo: popUpView.leftAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: popUpView.topAnchor).isActive = true
        
        
        self.view.bringSubviewToFront(visualEffectView)
        self.view.bringSubviewToFront(helperView)
        self.view.bringSubviewToFront(popUpView)
        self.view.bringSubviewToFront(wishButton)
        self.view.bringSubviewToFront(dropDownButton)
        self.view.bringSubviewToFront(dropDownButton.dropView)
        self.view.bringSubviewToFront(closeButton)
    
        popUpView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        dropDownButton.alpha = 0
        popUpView.alpha = 0
        wishButton.alpha = 0
        visualEffectView.alpha = 0
        closeButton.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.alpha = 1
            self.wishButton.alpha = 1
            self.popUpView.alpha = 1
            self.dropDownButton.alpha = 1
            self.closeButton.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    

    @objc func wishButtonTapped(){
        dismissPopUpView()
        insertWish()
    }
    
    
    func dismissPopUpView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.wishButton.alpha = 0
            self.popUpView.alpha = 0
            self.visualEffectView.alpha = 0
            self.dropDownButton.alpha = 0
            self.closeButton.alpha = 0
        }) { (_) in
            self.dropDownButton.dismissDropDown()
            self.dropDownButton.removeFromSuperview()
            self.wishButton.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.popUpView.removeFromSuperview()
            self.helperView.removeFromSuperview()
        }
    }
    
    func insertWish(){
    
        // append the new wish to the user's currently selected wishlist
        userWishListData[selectedWishlistIDX!].append(Wish(withWishName: popUpView.whishName!, checked: false))
        // set the updated data as the data for the table view
//        theTableView.wishList = userWishListData[currentWishListIDX]
//        theTableView.tableView.reloadData()
        
        // save Wish to database -> DataHandler
        saveWish()
   
    }
    
    
}

extension MainViewController: ClassBDelegate {
    func childVCDidComplete( with image: UIImage?, index: Int?) {
            self.currentImageArrayIDX = index!
            self.image = image!
            self.imagePreview.image = image!
            self.appDidEnterBackgroundHandler()
        }
}

extension MainViewController: SelectedWishlistProtocol{
    func didSelectWishlist(idx: Int) {
        self.selectedWishlistIDX = idx
    }
}




