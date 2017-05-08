//
//  CommentController.swift
//  Instragram20170417
//
//  Created by Nathan on 5/8/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var post:Post?{
        didSet{
            print(post?.user.username)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comment"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        collectionView?.keyboardDismissMode = .interactive
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.backgroundColor = UIColor.blue
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    lazy var viewd:UIView = {
        let viewd = UIView()
        viewd.backgroundColor = UIColor.white
        viewd.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let textfield = UITextField()
        textfield.placeholder = "Enter Comment"
        viewd.addSubview(textfield)
        textfield.anchor(top: viewd.topAnchor, left: viewd.leftAnchor, right: viewd.rightAnchor, bottom: viewd.bottomAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        return viewd
    }()
    override var inputAccessoryView: UIView?{
        get{
            
            return viewd
            }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }

}
