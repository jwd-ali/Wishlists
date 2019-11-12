//
//  HomeViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//
 
import UIKit
 
struct CustomData {
    var title: String
    var image: UIImage
}
 
// main Wishlist cell
class MainWishlistCell: UICollectionViewCell {
   
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "logoGroß")
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
   
    func addShadow() {
        let cornerRadius: CGFloat = 5
        self.wishlistImage.layer.shadowPath = UIBezierPath(roundedRect: self.wishlistImage.bounds, cornerRadius: cornerRadius).cgPath
        self.wishlistImage.layer.shadowRadius = cornerRadius
        self.wishlistImage.layer.shadowOffset = .zero
        self.wishlistImage.layer.shadowOpacity = 0.3
        self.wishlistImage.layer.shadowRadius = 10
        self.wishlistImage.layer.cornerRadius = cornerRadius
        self.wishlistImage.layer.shadowColor = UIColor.black.cgColor
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
    var once = true
 
    override func layoutSubviews() {
       super.layoutSubviews()
       if once {
          addShadow()
          once = false
       }
    }
   
    func commonInit() -> Void {
        contentView.addSubview(wishlistImage)
        contentView.addSubview(wishlistLabel)
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
        ])
       
       
    }
}
 
 
// simple cell with label
class ContentCell: UICollectionViewCell {
    
    
    let testImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "logoGroß")
        v.backgroundColor = .cyan
        return v
    }()
     
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
//        v.backgroundColor = .cyan
        return v
    }()
   
    let testLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Test Label"
        v.font = UIFont(name: "AvenirNext-Medium", size: 18)
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
//        contentView.addSubview(theLabel)
        contentView.layer.cornerRadius = 3.0;
        contentView.addSubview(testLabel)
        contentView.addSubview(testImage)
        // constrain label to all 4 sides
        NSLayoutConstraint.activate([
//            theLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            theLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            theLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            theLabel.heightAnchor.constraint(equalToConstant:150),
           
            testImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            testImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            testImage.heightAnchor.constraint(equalToConstant:150),
 
            testLabel.topAnchor.constraint(equalTo: testImage.bottomAnchor,constant: 1),
            testLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
 
}
 
// simple cell with button
class AddItemCell: UICollectionViewCell {
 
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("+", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 40.0)
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
        contentView.backgroundColor = .green
        contentView.addSubview(btn)
        // constrain button to all 4 sides
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: contentView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        btn.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
 
    @objc func didTap(_ sender: Any) {
        // tell the collection view controller we got a button tap
        tapCallback?()
    }
 
}
 



class ExampleViewController: UIViewController, UICollectionViewDataSource {
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
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    )
 
    // track collection view frame change
    var colViewWidth: CGFloat = 0.0
 
    // example data --- this will be filled with simple number strings
    var theData: [String] = [String]()
    var imageData: [UIImage] = [UIImage]()
    
    var image: UIImage?

   
    func styleTextField(_ textfield:UITextField) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePreview.image = UIImage(named: "logoGroß")
        imagePreview.layer.cornerRadius = 3
        
        //set up popUpView
        self.createListButton.layer.cornerRadius = 2
        self.listNameTextfield.tintColor = .lightGray
        self.listNameTextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1.5)
        self.blurrImage.transform = CGAffineTransform(translationX: 0, y: 1000)
        self.newListView.transform = CGAffineTransform(translationX: 0, y: 1000)
       
        //set CollectionView to bottom
            self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 500)
       
        //animate collectionView
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.theCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
       
        //animate welcomeLabel
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
           
            self.welcomeTextLabel.transform = CGAffineTransform(translationX: 228, y: 0)
 
           
        })
        
        view.addSubview(theCollectionView)
 
        // constrain collection view
        //      100-pts from top
        //      60-pts from bottom
        //      40-pts from leading
        //      40-pts from trailing
        NSLayoutConstraint.activate([
            theCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180.0),
            theCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            theCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
        ])
 
        // register the two cell classes for reuse
        theCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
        theCollectionView.register(AddItemCell.self, forCellWithReuseIdentifier: "AddItemCell")
        theCollectionView.register(MainWishlistCell.self, forCellWithReuseIdentifier: "MainWishlistCell")
 
        // set collection view dataSource
        theCollectionView.dataSource = self
 
        // use custom flow layout
        theCollectionView.collectionViewLayout = columnLayout
       
        self.view.sendSubviewToBack(theCollectionView)
        self.view.sendSubviewToBack(backGroundImage)
       
 
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    // DonMag3 - change "sender: Any" to "sender: Any?" so we can call this
    // DonMag3 - from "Liste erstellen" button tap
    @IBAction func closeButtonTappedNewList(_ sender: Any?) {
        
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
        // return 1 more than our data array (the extra one will be the "add item" cell
        return theData.count + 2
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               
        // if item is less that data count, return a "Content" cell
       // DonMag2 - changed the item -> data count checking, so "Wish List" cell will always
       // DOnMag2 - be displayed first, "Add Item" cell displayed last
     
       // if item is Zero (the first cell to be displayed), show the "Wish List" cell
       if indexPath.item == 0 {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainWishlistCell", for: indexPath) as! MainWishlistCell
           return cell
       }
     
       // if item is less than or equal to data count, return a "Content" cell
       // arrays are zero-based, so get the data element from item -1
       else if indexPath.item <= theData.count {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
        // DonMag3 -- change cell.theLabel to cell.testLabel
           cell.testLabel.text = theData[indexPath.item - 1]
        cell.testImage.image = self.image
            cell.testImage.image = imageData[indexPath.item - 1]
            
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

 
       }
 
       return cell
 
    }
    
    //hide keyboard, wenn user außerhalb toucht
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    @IBAction func createListButtonTapped(_ sender: Any) {
       
        // DonMag3 - "Liste erstellen" button was tapped
       
        if let txt = listNameTextfield.text {
            
            self.newListTextfield.resignFirstResponder()
           
            // append user-entered text to the data array
            self.theData.append(txt)
            self.imageData.append(UIImage(named: "logoGroß")!)
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
        print("editButtonTapped")
    }
    
}

extension ExampleViewController: ClassBDelegate {
        func childVCDidComplete( with image: UIImage?) {
            self.image = image!
        }
}

 
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
