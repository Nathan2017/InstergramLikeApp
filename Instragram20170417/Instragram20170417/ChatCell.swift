//
//  ChatCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/24/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class ChatCell: UICollectionViewCell {
    var message:Message?{
        didSet{
            guard let partnerid = FIRAuth.auth()?.currentUser?.uid == message?.toId ? message?.fromId : message?.toId else {return}
            guard let toid = message?.toId else {return}
            if let text = message?.text {
                messagelabel.text = text
            }
            else if let msgimage = message?.imageurl{
                if FIRAuth.auth()?.currentUser?.uid == message?.fromId {
                    self.messagelabel.text = "You send an image"
                }
                else if FIRAuth.auth()?.currentUser?.uid == message?.toId{
                    FIRDatabase.database().fetchuserpost(userid: (message?.fromId)!, completetion: { (user) in
                        self.messagelabel.text = "\(user.username) send an image"
                    })
                }
            }
            guard let date:Date = message?.timestamp else {return}
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            let datestring = dateformatter.string(from: date)
            timelabel.text = datestring
            
            FIRDatabase.database().fetchuserpost(userid: partnerid) { (user) in
                let imageurl = user.imageurl
                let username = user.username
                self.usernamelabel.text = username
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
                        if url.absoluteString != user.imageurl {
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
            }
           
        }
    }
    var sepline:UIView = {
       let sp = UIView()
        
        sp.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        return sp
    }()
    var imageview:UIImageView = {
        let imageview = UIImageView()
        
        imageview.layer.cornerRadius = 40
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        //imageview.backgroundColor = UIColor.red
        return imageview
        
        
    }()
    var usernamelabel:UILabel = {
       let ul = UILabel()
        
        ul.font = UIFont.boldSystemFont(ofSize: 18)
        
        return ul
        
        
    }()
    var timelabel:UILabel = {
       let tl = UILabel()
        tl.font = UIFont.boldSystemFont(ofSize: 12)
        tl.text = "HH:MM AM"
        tl.textAlignment = .center
        tl.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        return tl
        
    }()
    var messagelabel:UILabel = {
       let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 14)
        ml.textColor = UIColor.darkGray
        return ml
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageview.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        addSubview(sepline)
        sepline.anchor(top: bottomAnchor, left: imageview.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        addSubview(timelabel)
        timelabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timelabel.anchor(top: nil, left: nil, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: -10
            , paddingBottom: 0, width: 80
            , height: 30)
        addSubview(usernamelabel)
        usernamelabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernamelabel.anchor(top: nil, left: imageview.rightAnchor, right: timelabel.leftAnchor,
                             bottom: nil, paddingTop: 0, paddingLeft: 15, paddingRight: 0, paddingBottom: 0, width: 0, height: 80)
        
        addSubview(messagelabel)
        messagelabel.anchor(top: usernamelabel.bottomAnchor, left: usernamelabel.leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: -30, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
