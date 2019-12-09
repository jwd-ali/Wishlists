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
 
struct CustomData {
    var title: String
    var image: UIImage
}
 
// MARK: Main Wishlist cell
class MainWishlistCell: UICollectionViewCell {
    
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "iconRoundedImage")
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        v.layer.shadowRadius = 3
        v.layer.shadowColor = UIColor.darkGray.cgColor
        return v
    }()
   
    let wishlistLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Main Wishlist"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
    override func layoutSubviews() {
       super.layoutSubviews()
    }
   
    func commonInit() -> Void {
        contentView.addSubview(wishlistImage)
        contentView.addSubview(wishlistLabel)
        contentView.addSubview(btn)

        // constrain view to all 4 sides
        NSLayoutConstraint.activate([
            wishlistImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            wishlistImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wishlistImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wishlistImage.heightAnchor.constraint(equalToConstant:150),
           
            wishlistLabel.topAnchor.constraint(equalTo: wishlistImage.bottomAnchor,constant: 1),
            wishlistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            wishlistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wishlistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            btn.topAnchor.constraint(equalTo: contentView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
       btn.addTarget(self, action: #selector(mainWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var wishlistTapCallback: (() -> ())?
    
    @objc func mainWishlistTapped(_ sender: Any) {
        // tell the collection view controller we got a button tap
        wishlistTapCallback?()
    }
}
 
 
// MARK: Simple Whishlist Cell
class ContentCell: UICollectionViewCell {
    
    let buttonView: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        v.layer.shadowRadius = 3
        v.layer.shadowColor = UIColor.darkGray.cgColor
        return v
    }()
     
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        return v
    }()
   
    let testLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Test Label"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
 
    func commonInit() -> Void {

        contentView.layer.cornerRadius = 3.0;
        contentView.addSubview(testLabel)
        contentView.addSubview(buttonView)
        // constrain label to all 4 sides
        NSLayoutConstraint.activate([

            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant:150),
 
            testLabel.topAnchor.constraint(equalTo: buttonView.bottomAnchor,constant: 1),
            testLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
 
// MARK: Add WishList Cell
class AddItemCell: UICollectionViewCell {
 
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitleColor(.darkGray, for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 40.0)
        return v
    }()
    
    let label: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "neue Wishlist erstellen"
        v.numberOfLines = 0
        v.font = UIFont(name: "AvenirNext", size: 20)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
    
    let plusLabel: UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "+"
        v.font = UIFont(name: "AvenirNext-Bold", size: 30)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
 
    // this will be used as a "callback closure" in collection view controller
    var tapCallback: (() -> ())?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
 
    func commonInit() -> Void {
        contentView.layer.cornerRadius = 3.0;
        contentView.addSubview(btn)
        contentView.addSubview(label)
        contentView.addSubview(plusLabel)
        

        // constrain button to all 4 sides
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: contentView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            plusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            plusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            plusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            plusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
        ])
        btn.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
 
    @objc func didTap(_ sender: Any) {
        // tell the collection view controller we got a button tap
        tapCallback?()
    }
 
}

// DonMag3 - protocol / delegate pattern
// allows wish table view (and cell) to update wish list data
protocol DeleteWishDelegate {
    func deleteWish(_ idx: Int)
}

// MARK: ViewController
// DonMag3 - conform to DeleteWishDelegate protocol
class ExampleViewController: UIViewController, UICollectionViewDataSource, DeleteWishDelegate {
    
    
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
    
    // MARK: CustomWishlistView
    
    
    
    // MARK: WishListView
    
    let wishlistView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 30
        return v
    }()
    
    lazy var theTableView: WhishlistTableViewController = {
       let v = WhishlistTableViewController()
        v.view.layer.masksToBounds = true
        v.view.layer.borderColor = UIColor.white.cgColor
        v.view.backgroundColor = .clear
        v.view.layer.borderWidth = 7.0
        v.view.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let dismissWishlistViewButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "dropdown"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(hideView), for: .touchUpInside)
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
        v.text = "Main Wishlist"
        v.font = UIFont(name: "AvenirNext-Bold", size: 30)
        v.textColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishCounterLabel: UILabel = {
        let v = UILabel()
        v.text = "5 unerfüllte Wünsche"
        v.font = UIFont(name: "AvenirNext", size: 12)
        v.textColor = .white
        v.font = v.font.withSize(12)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "iconRoundedImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    // MARK: PopUpView
    
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
        v.clipsToBounds = true
//        v.contentVerticalAlignment = .fill
//        v.contentHorizontalAlignment = .fill
        return v
    }()
    
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
    private let images: [UIImage] = [
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
    
    // DonMag3 - array of wish lists
    // this will eventually be managed by some type of data handler class
    var userWishListData: [[Wish]] = [[Wish]]()
    
    // DonMag3 - track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePreview.image = UIImage(named: "iconRoundedImage")
        image = UIImage(named: "iconRoundedImage")
        
        
        
        
        
        // set up popUpView
        self.createListButton.layer.cornerRadius = 2
        self.listNameTextfield.tintColor = .lightGray
        self.listNameTextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.5)
        self.blurrImage.transform = CGAffineTransform(translationX: 0, y: 1000)
        self.newListView.transform = CGAffineTransform(translationX: 0, y: 1000)
       
        // set CollectionView to bottom
            self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 500)
       
        // animate collectionView
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // retrieve firstname from DB and animate welcomeTextLabel
        setupWelcomeLabel()
        
        // hide wishlistView
        self.wishlistView.transform = CGAffineTransform(translationX: 0, y: 1000)
        
        // add slideDown-gesture to WishlistView
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        view.addGestureRecognizer(slideDown)
        
        // adding notification from `ContainerViewController` so `addButtonTapped` is accessable here
        NotificationCenter.default.addObserver(self, selector: #selector(self.addWishButtonTapped(notification:)), name: Notification.Name("addWishButtonTapped"), object: nil)

        // MARK: Views + Constraints
        view.addSubview(theCollectionView)
        view.addSubview(wishlistView)
        
        wishlistView.addSubview(dismissWishlistViewButton)
        wishlistView.addSubview(menueButton)
        wishlistView.addSubview(wishlistLabel)
        wishlistView.addSubview(wishlistImage)
        wishlistView.addSubview(wishCounterLabel)
        wishlistView.addSubview(theTableView.tableView)
        addChild(theTableView)
 
        NSLayoutConstraint.activate([
            
            // constrain collectionView
            theCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180.0),
            theCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            theCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
            
            // constrain wishlistView
            wishlistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120.0),
            wishlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wishlistView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            wishlistView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
            
            // constrain tableView
            theTableView.view.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 180.0),
            theTableView.view.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: 0),
            theTableView.view.leadingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theTableView.view.trailingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
           
            // constrain dropDownButton
            dismissWishlistViewButton.topAnchor.constraint(equalTo: wishlistView.topAnchor),
            dismissWishlistViewButton.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: -650),
            dismissWishlistViewButton.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor),
            dismissWishlistViewButton.trailingAnchor.constraint(equalTo: wishlistView.trailingAnchor, constant: -260),
            
            
            // constrain menueButton
            menueButton.topAnchor.constraint(equalTo: wishlistView.topAnchor),
            menueButton.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: -650),
            menueButton.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 260),
            menueButton.trailingAnchor.constraint(equalTo: wishlistView.trailingAnchor),
            
            // constrain wishlistImage
            wishlistImage.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: -570),
            wishlistImage.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 30),
            wishlistImage.widthAnchor.constraint(equalToConstant: 80),
            wishlistImage.heightAnchor.constraint(equalToConstant: 80),
            
            //constrain wishlistlabel
            wishlistLabel.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: -600),
            wishlistLabel.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 115),
            
            // constrain wishCounterLabel
            wishCounterLabel.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: -585),
            wishCounterLabel.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 115),
            
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
        
        self.view.sendSubviewToBack(wishlistView)
        self.view.sendSubviewToBack(theCollectionView)
        self.view.sendSubviewToBack(backGroundImage)
        
        // DonMag3 - set DeleteWishDelegate protocol for the table
        theTableView.deleteWishDelegate = self
        
        // DonMag 3 - hide collection view while data is retirieved from server
        theCollectionView.isHidden = true

        // DonMag 3 - get the data from the server
        retrieveUserDataFromDB()

    }

    // DonMag3 - simulate retrieving user wishlists from database
    // when you're further along in development, you may be retrieving
    // this data when you log-in the user
    func retrieveUserDataFromDB() -> Void {
        
        // show a spinner Activity Indicator
        let spinnerView = UIActivityIndicatorView(style: .whiteLarge)
        spinnerView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.layer.cornerRadius = 20.0
        view.addSubview(spinnerView)
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: 120),
            spinnerView.heightAnchor.constraint(equalToConstant: 120),
        ])
        spinnerView.startAnimating()

        // simulate 1.0 seconds to retrieve data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            // local mutable "WishList" var
            var wList: [Wish] = [Wish]()
            
            // simlate user data from server
            var retrievedData: [[String : Any]] = [
                [
                    "listName" : "Main Wishlist",
                    "listImageIndex" : -1,
                    "wishes" : ["Ein Auto", "Ein Fahrrad"]
                ],
                [
                    "listName" : "My List",
                    "listImageIndex" : 1,
                    "wishes" : ["Ein Bier", "Kuemmerling", "Viele Freunde"]
                ]
            ]
            
            // un-comment next line to simulate First-Time user (no saved data yet)
            //retrievedData = [["" : ""]]
            
            var hasUserData = false
            if let _ = retrievedData.first?["listName"] {
                hasUserData = true
            }

            if hasUserData {
                
                retrievedData.forEach { userData in

                    // make sure the data is valid
                    guard let listName = userData["listName"] as? String,
                        let listImageIDX = userData["listImageIndex"] as? Int,
                        let wishes = userData["wishes"] as? [String]
                        else { fatalError("Bad Data - implement better error handling") }
                    
                    self.wishListTitlesArray.append(listName)
                    if listImageIDX == -1 {
                        self.wishListImagesArray.append(UIImage(named: "iconRoundedImage")!)
                    } else {
                        self.wishListImagesArray.append(self.images[1])
                    }

                    wList = [Wish]()
                    
                    wishes.forEach {
                        wList.append(Wish(withWishName: $0, checked: false))
                    }

                    self.userWishListData.append(wList)
                    
                }

            } else {
                
                // no data from server, so this is a first time user
                
                // data will ALWAYS start with "Main Wishlist"
                self.wishListTitlesArray.append("Main Wishlist")
                self.wishListImagesArray.append(UIImage(named: "iconRoundedImage")!)
                
                // create an empty wishlist, in case this is a new user
                wList = [Wish]()
                self.userWishListData.append(wList)

            }
            
            // un-hide the collection view
            self.theCollectionView.isHidden = false
            
            // remove the activity view
            spinnerView.removeFromSuperview()
            
            // reload the collection view
            self.theCollectionView.reloadData()
            
        }

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
        imageTimer = Timer(fire: Date(), interval: 2.5, repeats: true) { (timer) in
            UIView.transition(with: self.imagePreview,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                let imageStore = self.images.randomElement()
                self.imagePreview.image = imageStore
                self.image = imageStore
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
               
        // DonMag3 - "Main Wishlist" is now at item Zero in the
        // wish lists array, so no need to treat it differently than
        // any other list
        
        // if indexPath.item is less than data count, return a "Content" cell
        if indexPath.item < wishListTitlesArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            cell.testLabel.text = wishListTitlesArray[indexPath.item]
            
            cell.buttonView.setImage(wishListImagesArray[indexPath.item], for: .normal)
            
            cell.customWishlistTapCallback = {
                // let wishlistView appear
                
                // DonMag3 - track selected index
                self.currentWishListIDX = indexPath.item
                // update label in wishList view
                self.wishlistLabel.text = self.wishListTitlesArray[indexPath.item]
                // update image in wishList view
                self.wishlistImage.image = self.wishListImagesArray[indexPath.item]
                // update the data for in wishList table view
                self.theTableView.wishList = self.userWishListData[indexPath.item]
                // reload wishList table
                self.theTableView.tableView.reloadData()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.wishlistView.transform = CGAffineTransform(translationX: 0, y: 0)
                })
                // let welcomeText disappear
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.welcomeTextLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                })
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
    
    func createCustomWishlistView() -> CustomWishlistView {
        let v = CustomWishlistView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 30
        return v
    }
 
    @IBAction func createListButtonTapped(_ sender: Any) {
        
       
        // "Liste erstellen" button was tapped
        self.appDidEnterBackgroundHandler()
       
        if let txt = listNameTextfield.text {
            
            self.newListTextfield.resignFirstResponder()
           
            // append user-entered text to the data array
            self.wishListTitlesArray.append(txt)
            self.wishListImagesArray.append(self.image!)
            
            // DonMag3 - append new empty wish array
            self.userWishListData.append([Wish]())
            
            let theCustomWishlistView = createCustomWishlistView()
            
            self.view.addSubview(theCustomWishlistView)
            // constrain CustomWishlistView
            theCustomWishlistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120.0).isActive = true
            theCustomWishlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            theCustomWishlistView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
            theCustomWishlistView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
            theCustomWishlistView.wishlistImage.image = self.image
            theCustomWishlistView.wishlistLabel.text = txt
            theCustomWishlistView.transform = CGAffineTransform(translationX: 0, y: 1000)
            
            self.view.bringSubviewToFront(containerView)
            
            
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
    
    // MARK: WishlistView

    // swipe down to dismiss
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        hideView()
    }
    
    @objc func hideView(){
        //animate welcomeLabel
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            
            // show welcomeText
            self.welcomeTextLabel.transform = CGAffineTransform(translationX: 278, y: 0)
            // hide wishlistView
            self.wishlistView.transform = CGAffineTransform(translationX: 0, y: 1000)
        })
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            
            // hide wishlistView
            self.wishlistView.transform = CGAffineTransform(translationX: 0, y: 1000)
        })
    }
    
    @objc func menueButtonTapped(){
        print("menueButton tapped")
    }
    
    // MARK: wishPopUpView
    
    @objc func addWishButtonTapped(notification : Notification){
        
        popUpView.popUpTextField.text = ""
        
        view.addSubview(visualEffectView)
        view.addSubview(popUpView)
        view.addSubview(wishButton)
        
        
        // constrain blurrEffectView
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // constrain popUpView
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        popUpView.widthAnchor.constraint(equalToConstant: view.frame.width - 85).isActive = true
        
        // constrain wishButton
        wishButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        wishButton.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor, constant: 65).isActive = true
        wishButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        wishButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        self.view.bringSubviewToFront(visualEffectView)
        self.view.bringSubviewToFront(popUpView)
        self.view.bringSubviewToFront(wishButton)
    
        popUpView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        wishButton.alpha = 0
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.alpha = 1
            self.wishButton.alpha = 1
            self.popUpView.alpha = 1
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
        }) { (_) in
            self.popUpView.removeFromSuperview()
            self.wishButton.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    func insertWish(){
        // DonMag3 - append the new wish to the user's currently selected wishlist
        userWishListData[currentWishListIDX].append(Wish(withWishName: popUpView.whishName!, checked: false))
        // set the updated data as the data for the table view
        theTableView.wishList = userWishListData[currentWishListIDX]
        theTableView.tableView.reloadData()
    }
    
    func deleteWish(_ idx: Int){
        // DonMag3 - remove the wish from the user's currently selected wishlist
        var wishes: [Wish] = userWishListData[currentWishListIDX]
        wishes.remove(at: idx)
        userWishListData[currentWishListIDX] = wishes
        // set the updated data as the data for the table view
        theTableView.wishList = userWishListData[currentWishListIDX]
        theTableView.tableView.reloadData()
    }
    
}

extension ExampleViewController: ClassBDelegate {
        func childVCDidComplete( with image: UIImage?) {
            self.image = image!
            self.imagePreview.image = image!
            self.appDidEnterBackgroundHandler()
        }
}

// MARK: Custom Flowlayout

// custom FlowLayout class to left-align collection view cells
// found here: https://stackoverflow.com/a/49717759/6257435
class FlowLayout: UICollectionViewFlowLayout {

    required init(itemSize: CGSize, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()

        self.itemSize = itemSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }

        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Set the initial left inset
            var leftInset = sectionInset.left

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return layoutAttributes
    }
}

// MARK: CenterFlowLayout

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var itemSize: CGSize {
        get { return CGSize(width: 150, height: 150) }
        set {}
    }
        
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }

        // Constants
        let leftPadding: CGFloat = 8
        let interItemSpacing = minimumInteritemSpacing

        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in

            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {

                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding

                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)

            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }

        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in

            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {

                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding

                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin

                currentRow += 1
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
