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
    var refreshcontrol:UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NSNotification.Name(rawValue: "autorefresh")
        NotificationCenter.default.addObserver(self, selector: #selector(handleautorefresh), name: name, object: nil)
        navigationItem.title = "News Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        fetchallpost()
        fetchfollowpost()
        
        refreshcontrol = UIRefreshControl()
        refreshcontrol?.addTarget(self, action: #selector(handlerefresh), for: .valueChanged)
        collectionView?.addSubview(refreshcontrol!)
    }
    func handleautorefresh(){
        handlerefresh()
    }
    func handlerefresh(){
         self.posts.removeAll()
               print(posts.count)
        fetchallpost()
        fetchfollowpost()
        
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
        if posts.count > 0
        {
            cell.post = posts[indexPath.item]
        }
        
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
        FIRDatabase.database().fetchuserpost(userid: userid) { (user) in
            self.fetchpostwithuser(user: user)
        }
       
        
    
    }
    func fetchpostwithuser(user:User){
                    FIRDatabase.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                         self.refreshcontrol?.endRefreshing()
                        guard let dict = snapshot.value as? [String:Any] else {return}
                        dict.forEach({ (key,value) in
                            guard let dict3 = value as? [String:Any] else {return}
                            self.posts.append(Post(user: user, dictionary: dict3))
                        })
                        self.posts.sort(by: { (p1, p2) -> Bool in
                            return p1.date.compare(p2.date) == .orderedDescending
                        })
                        self.collectionView?.reloadData()
                    }) { (error) in
                        print(error)
                        return
                    }
    }
    func fetchfollowpost(){
        guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
        print(userid)
        let ref = FIRDatabase.database().reference().child("following")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userid) {
                ref.child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String:Any] else {return}
                    dictionary.forEach({ (key,value) in
                        FIRDatabase.database().fetchuserpost(userid: key, completetion: { (user) in
                            self.fetchpostwithuser(user: user)
                        })
                    })
                })
            }
            else {
                self.collectionView?.reloadData()
                return
            }
        })
        
    }

}
