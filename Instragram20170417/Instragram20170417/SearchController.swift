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

class SearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIGestureRecognizerDelegate {
    var users = [User]()
    var filteruser = [User]()
    lazy var searchcontrol:UISearchBar = {
       let search = UISearchBar()
        search.placeholder = "Enter Username"
        search.autocorrectionType = UITextAutocorrectionType.no
        search.autocapitalizationType = UITextAutocapitalizationType.none
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        search.delegate = self
        return search
    }()
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cancelbuttonwidthanchor?.constant = 50
        searchcontrolrightAnchor?.constant = -74
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    lazy var cancelbutton:UIButton = {
       let cb = UIButton(type: .system)
        cb.setTitle("Cancel", for: .normal)
        //cb.backgroundColor = UIColor.red
        cb.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cb.addTarget(self, action: #selector(dismisssearch), for: .touchUpInside)
        return cb
    }()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteruser = self.users
        }
        else
        {
        self.filteruser = self.users.filter { (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        }
        self.collectionView?.reloadData()
    }
    var cancelbuttonwidthanchor:NSLayoutConstraint?
    var searchcontrolrightAnchor:NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        let navv = navigationController?.navigationBar
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelbutton)
        navv?.addSubview(searchcontrol)
        searchcontrol.anchor(top: navv?.topAnchor, left: navv?.leftAnchor, right: nil, bottom: navv?.bottomAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: -12, width: 0, height: 0)
        searchcontrolrightAnchor = searchcontrol.rightAnchor.constraint(equalTo: (navv?.rightAnchor)!, constant: -12)
        searchcontrolrightAnchor?.isActive = true
        navv?.addSubview(cancelbutton)
        cancelbutton.anchor(top: navv?.topAnchor, left: nil, right: navv?.rightAnchor, bottom: navv?.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: -12, paddingBottom: 0, width: 0, height: 0)
        cancelbuttonwidthanchor = cancelbutton.widthAnchor.constraint(equalToConstant: 0)
        cancelbuttonwidthanchor?.isActive = true
        self.collectionView!.register(UserSearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        fetchuser()
        
        
    }
    func dismisssearch(){
        searchcontrol.resignFirstResponder()
        searchcontrol.text = nil
        cancelbuttonwidthanchor?.constant = 0
        searchcontrolrightAnchor?.constant = -12
        self.filteruser = self.users
        self.collectionView?.reloadData()
        self.view.layoutIfNeeded()
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func viewWillAppear(_ animated: Bool) {
        searchcontrol.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchcontrol.isHidden = true
        cancelbuttonwidthanchor?.constant = 0
        searchcontrolrightAnchor?.constant = -12
        self.view.layoutIfNeeded()
        searchcontrol.resignFirstResponder()
        let selecteduser = self.filteruser[indexPath.item]
        let pro = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        pro.userid = selecteduser.uid
                self.navigationController?.pushViewController(pro, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return filteruser.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSearchCell
    
        cell.user = self.filteruser[indexPath.item]
    
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
                guard let dict = value as? [String:Any] else {return}
                let userid = FIRAuth.auth()?.currentUser?.uid
                if key != userid {
                    self.users.append(User(uid:key,dictionary: dict))
                }
                
            })
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.lowercased().compare(u2.username.lowercased()) == .orderedAscending
            })
            self.filteruser = self.users
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
            return
        }
    }

}
