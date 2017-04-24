//
//  ChatView.swift
//  Instragram20170417
//
//  Created by Nathan on 4/24/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class ChatView: UICollectionViewController {
    var user:User?{
        didSet{
            guard let username = user?.username else {return}
            self.navigationItem.title = username
        }
    }
    var container:UIView = {
       let con = UIView()
        con.backgroundColor = UIColor.white
        return con
        
    }()
    var enterfild:UITextField = {
       let en = UITextField()
        en.placeholder = "Enter Text"
        
        return en
        
    }()
    var sepline:UIView = {
        let sep = UIView()
        
        sep.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return sep
        
    }()
    lazy var sendbutton:UIButton = {
       let send = UIButton(type: .system)
        send.setTitle("Send", for: .normal)
        send.setTitleColor(.white, for: .normal)
        send.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 230/255, alpha: 1)
        send.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        send.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        return send
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomLayoutGuide.topAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        container.addSubview(sendbutton)
        sendbutton.anchor(top: container.topAnchor, left: nil, right: container.rightAnchor, bottom: container.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 80, height: 0)
        container.addSubview(enterfild)
        enterfild.anchor(top: container.topAnchor, left: container.leftAnchor, right: sendbutton.leftAnchor, bottom: container.bottomAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        container.addSubview(sepline)
        sepline.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        

    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    func handlesend() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        guard let toid = user?.uid else {return}
        let timestamp = Date().timeIntervalSince1970
        FIRDatabase.database().reference().child("messages").child(uid).child(toid).childByAutoId().setValue(["text":enterfild.text,"timestampe":timestamp] as? [String:Any]) { (error, ref) in
            print("Success")
        }
    }

}
