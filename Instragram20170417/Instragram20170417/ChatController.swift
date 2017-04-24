//
//  ChatController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/24/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class ChatController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var numchat = [String]()
    var followedusers = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //self.fetchfollowuser()
        self.fetchmessage()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return followedusers.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
    
        cell.user = followedusers[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatview = ChatView(collectionViewLayout: UICollectionViewFlowLayout())
        chatview.user = followedusers[indexPath.item]
        self.navigationController?.pushViewController( chatview, animated: true)
    }
    func fetchfollowuser(){
            guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
            FIRDatabase.database().reference().child("following").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                dictionary.forEach({ (key,value) in
                    FIRDatabase.database().fetchuserpost(userid: key, completetion: { (user) in
                        self.followedusers.append(user)
                        self.collectionView?.reloadData()
                    })
                })
                
                
                
            })
        
    }
    func fetchmessage(){
        guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
           guard let dict = snapshot.value as? [String:Any] else {return}
            dict.forEach({ (key,value) in
                FIRDatabase.database().fetchuserpost(userid: key, completetion: { (user) in
                    self.followedusers.append(user)
                    self.collectionView?.reloadData()
                })
            })
            
        })
    }


}
