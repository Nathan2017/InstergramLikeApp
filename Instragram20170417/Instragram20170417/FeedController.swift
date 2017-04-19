//
//  FeedController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    var username:String?
    var user:User?
    var dicts:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchallpost()

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.backgroundColor = UIColor.white
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 12+40+12
        height += view.frame.width
        height += 100
        return CGSize(width: view.frame.width, height: height)
    }
    func fetchallpost(){
        guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("users").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict2  = snapshot.value as? [String:Any] else {return}
            self.user = User(dictionary: dict2)
            FIRDatabase.database().reference().child("posts").child(userid).observe(.childAdded, with: { (snapshot) in
                guard let dict = snapshot.value as? [String:Any] else {return}
                guard let user = self.user else {return}
                self.posts.append(Post(user: user, dictionary: dict))
                self.posts = self.posts.reversed()
                self.collectionView?.reloadData()
            }) { (error) in
                print(error)
                return
            }
        }) { (error) in
            print(error)
            return
        }
       
        
       
    }

}
