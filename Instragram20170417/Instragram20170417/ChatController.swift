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
    var messagedicitonary = [String:Message]()
    var messages = [Message]()
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
        return self.messages.count
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        
        cell.message = self.messages[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let chatview = ChatView(collectionViewLayout: layout)
        chatview.userid = FIRAuth.auth()?.currentUser?.uid == self.messages[indexPath.item].toId ? self.messages[indexPath.item].fromId : self.messages[indexPath.item].toId
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
        let ref = FIRDatabase.database().reference().child("user-messages").child(userid)
        ref.observe(.childAdded, with: { (snapshot) in
            let mid = snapshot.key
            FIRDatabase.database().reference().child("messages").child(mid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let medictionary = snapshot.value as? [String:Any] else {return}
                guard let toid:String = medictionary["fromId"] as? String == userid ? medictionary["fromId"] as? String : medictionary["toId"] as? String else {return}
                self.messagedicitonary[toid] = Message(dictionary: medictionary)
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.handlereload), userInfo: nil, repeats: false)
                
            }, withCancel: nil)
            
        })
        
        
    }
    var timer: Timer?
    func handlereload(){
        self.messages = Array(self.messagedicitonary.values)
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timestamp > m2.timestamp
        })
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }


}
