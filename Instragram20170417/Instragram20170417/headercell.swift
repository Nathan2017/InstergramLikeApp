//
//  headercell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class headercell: UICollectionViewCell {
    var user:User? {
        didSet{
            username.text = user?.username
            guard let imageurl = user?.imageurl else {return}
            if let cacheimage = imagecache[imageurl] {
                self.imageview.image = cacheimage
            }
            else
            {
                guard let url = URL(string: imageurl) else {return}
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if url.absoluteString != self.user?.imageurl {
                        return
                    }
                    guard let data = data else {return}
                    let image = UIImage(data: data)
                    imagecache[url.absoluteString] = image
                    DispatchQueue.main.async {
                        self.imageview.image = image
                    }
                    
                    }.resume()
            }
           constructbutton()
        }
        
    }
    func constructbutton(){
        guard let currentuid = FIRAuth.auth()?.currentUser?.uid else {return}
        if user?.uid == currentuid {
            editprofilebutton.setTitle("Edit Profile", for: .normal)
        }
        else
        {
            FIRDatabase.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("following")
                {
                    FIRDatabase.database().reference().child("following").child(currentuid).observeSingleEvent(of: .value, with: { (snapshot) in
                        //print(snapshot.value)
                        guard let dict = snapshot.value as? [String:Any] else {return}
                        
                        guard let followinguseruid = self.user?.uid else {return}
                        if let followingstatus = dict[followinguseruid] as? Int
                        {
                            self.editprofilebutton.setTitle("Unfollow", for: .normal)
                            
                            
                        }
                        else
                        {
                            self.editprofilebutton.setTitle("Follow", for: .normal)
                        }
                    })
                    
                }
                else
                {
                    self.editprofilebutton.setTitle("Follow", for: .normal)
                }
            })
            
            editprofilebutton.setTitleColor(UIColor.white, for: .normal)
            editprofilebutton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 200/255, alpha: 1)
            editprofilebutton.layer.borderColor = UIColor.black.cgColor
        }
    }
    lazy var editprofilebutton:UIButton = {
       let epfb = UIButton(type: .system)
        epfb.layer.cornerRadius = 5
        //epfb.setTitle("Edit Profile", for: .normal)
        epfb.setTitleColor(UIColor.black, for: .normal)
        epfb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        epfb.layer.borderWidth = 1
        epfb.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        epfb.addTarget(self, action: #selector(editprofile), for: .touchUpInside)
        return epfb
    }()
    let sepview:UIView = {
       let sv = UIView()
        sv.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        return sv
        
    }()
    let username:UILabel = {
        let username = UILabel()
        username.font = UIFont.boldSystemFont(ofSize: 14)
        return username
    }()
    let imageview:UIImageView = {
       let imv = UIImageView()
        imv.layer.borderWidth = 1
        imv.layer.borderColor = UIColor.black.cgColor
        imv.layer.cornerRadius = 40
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sepview)
        sepview.anchor(top: bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        addSubview(imageview)
        imageview.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        addSubview(username)
        //username.centerXAnchor.constraint(equalTo: imageview.centerXAnchor).isActive = true
        username.anchor(top: imageview.bottomAnchor, left: leftAnchor ,right: rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 20, paddingRight: 0, paddingBottom: 0, width: 0, height: 30)
        addSubview(editprofilebutton)
        //editprofilebutton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editprofilebutton.anchor(top: nil, left: imageview.rightAnchor, right: rightAnchor, bottom: username.topAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 40)
    }
    func editprofile(){
        if self.editprofilebutton.titleLabel?.text == "Follow" {
            guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
           let ref = FIRDatabase.database().reference().child("following").child(userid)
            guard let followinguser = user?.uid else {return}
                let dict:[String:Any] = [followinguser : 1]
            ref.updateChildValues(dict, withCompletionBlock: { (error, reference) in
                if let error = error {
                    print(error)
                    return
                }
                print("save following db complete")
                self.editprofilebutton.setTitle("Unfollow", for: .normal)
            })
        }
        else if self.editprofilebutton.titleLabel?.text == "Unfollow"
        {
            guard let userid = FIRAuth.auth()?.currentUser?.uid else {return}
            let ref = FIRDatabase.database().reference().child("following").child(userid)
            guard let followinguser = user?.uid else {return}
           
            ref.child(followinguser).removeValue(completionBlock: { (error, reference) in
                print("complete remove")
                self.editprofilebutton.setTitle("Follow", for: .normal)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
