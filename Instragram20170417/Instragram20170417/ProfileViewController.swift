//
//  ProfileViewController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var user:User?
    var userid:String?
   var posts = [Post]()
    var barbuttonitem:UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(headercell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid")
        collectionView?.register(PorfileShareImageCell.self, forCellWithReuseIdentifier: "cellid")
        if let userrid = self.userid {
             barbuttonitem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
        else
        {
            barbuttonitem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(loggigout))
        }
        
        navigationItem.rightBarButtonItem = barbuttonitem
        
        
        fetchpost()
    }
    func fetchpost(){
        guard let uid = userid ?? FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with:
            { (snapshot) in
               
                guard let dict = snapshot.value as? [String:Any] else {return}
                self.user = User(uid:uid,dictionary: dict)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.user?.username
                    self.collectionView?.reloadData()
                }
                FIRDatabase.database().reference().child("posts").child(uid).observe(.childAdded, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String:Any] else {return}
                    guard let user = self.user else {return}
                    self.posts.append(Post(user:user,dictionary: dict))
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.date.compare(p2.date) == .orderedDescending
                    })
                    DispatchQueue.main.async {
                       self.collectionView?.reloadData()
                    }
                }) { (error) in
                    print(error)
                    return
                }
                
        }) { (error) in
            print("New Error",error)
            return
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid", for: indexPath) as! headercell
        header.user = self.user
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-5)/3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 1, bottom: 0, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cd = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PorfileShareImageCell
        cd.post = posts[indexPath.item]
        return cd
    }
    func loggigout(){
        let alertcontrol = UIAlertController()
        alertcontrol.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.handlelogout()
        }))
        alertcontrol.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertcontrol, animated: true, completion: nil)
    }
    func handlelogout(){
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch
        {
            
        }
        let navcon = UINavigationController(rootViewController: LoginViewController())
        self.present(navcon, animated: true, completion: nil)
    }

}
