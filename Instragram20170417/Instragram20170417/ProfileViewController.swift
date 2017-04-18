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
    var imageurl:String = ""
    var username:String = ""
   var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(headercell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid")
        collectionView?.register(PorfileShareImageCell.self, forCellWithReuseIdentifier: "cellid")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlelogout))
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with:
            { (snapshot) in
                guard let dict = snapshot.value as? [String:Any] else {return}
                DispatchQueue.main.async {
                    self.navigationItem.title = dict["username"] as? String
                    guard let image = dict["profileimageurl"] as? String else {return}
                    self.imageurl = image
                    guard let username2 = dict["username"] as? String else {return}
                    self.username = username2
                    self.collectionView?.reloadData()
                }
                
        }) { (error) in
            print("New Error",error)
            return
        }
        
        fetchpost()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func fetchpost(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("posts").child(uid).observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return}
            self.posts.append(Post(dictionary: dict))
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
            return
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid", for: indexPath) as! headercell
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.imageurl) else {return }
            guard let imagedata = NSData(contentsOf: url) else {return }
            DispatchQueue.main.async {
                header.imageview.image = UIImage(data: imagedata as Data)
                header.username.text = self.username
            }
        }
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
