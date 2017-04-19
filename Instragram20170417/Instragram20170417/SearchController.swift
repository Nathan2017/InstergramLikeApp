//
//  SearchController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/19/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class SearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var users = [User]()
    let searchcontrol:UISearchBar = {
       let search = UISearchBar()
        search.placeholder = "Enter Username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return search
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let navv = navigationController?.navigationBar
        navv?.addSubview(searchcontrol)
        searchcontrol.anchor(top: navv?.topAnchor, left: navv?.leftAnchor, right: navv?.rightAnchor, bottom: navv?.bottomAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: -12, paddingBottom: -12, width: 0, height: 0)
        self.collectionView!.register(UserSearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        fetchuser()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelsearch)))
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSearchCell
    
        cell.user = self.users[indexPath.item]
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func cancelsearch(){
        searchcontrol.resignFirstResponder()
    }
    func fetchuser(){
        FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            dictionary.forEach({ (key,value) in
                print(key,value)
                guard let dict = value as? [String:Any] else {return}
                self.users.append(User(dictionary: dict))
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
            return
        }
    }

}
