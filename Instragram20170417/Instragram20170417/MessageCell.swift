//
//  MessageCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/25/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class MessageCell: UICollectionViewCell {
    var message:Message?{
        didSet{
            textview.text = message?.text
            guard let toid = message?.fromId == FIRAuth.auth()?.currentUser?.uid ? message?.toId : message?.fromId else {return}
            FIRDatabase.database().fetchuserpost(userid: toid) { (user) in
                let imageurl = user.imageurl
                let username = user.username
                if let cacheimage = imagecache[imageurl] {
                    self.profileimageview.image = cacheimage
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
                            self.profileimageview.image = image
                        }
                        
                        }.resume()
                }
            }
        }
    }
    let bubbleview:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 200/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
        
    }()
    let textview:UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
        
        
    }()
    let profileimageview:UIImageView = {
       let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 16
        piv.clipsToBounds = true
        //piv.backgroundColor = UIColor.red
        return piv
        
        
    }()
    var bubbleviewwidthanchor:NSLayoutConstraint?
    var bubbleviewrightanchor:NSLayoutConstraint?
    var bubbleviewleftanchor:NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleview)
        addSubview(profileimageview)
        profileimageview.anchor(top: nil, left: leftAnchor, right: nil, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 32, height: 32)
        bubbleviewwidthanchor = bubbleview.widthAnchor.constraint(equalToConstant: 200)
        bubbleviewwidthanchor?.isActive = true
        bubbleviewrightanchor = bubbleview.rightAnchor.constraint(equalTo: rightAnchor,constant:-8)
        bubbleviewrightanchor?.isActive = true
        bubbleviewleftanchor = bubbleview.leftAnchor.constraint(equalTo: profileimageview.rightAnchor,constant:8)
        //bubbleviewleftanchor?.isActive = true
        bubbleview.anchor(top: topAnchor, left: nil, right: nil, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        addSubview(textview)
        textview.centerXAnchor.constraint(equalTo: bubbleview.centerXAnchor).isActive = true
        textview.widthAnchor.constraint(equalTo: bubbleview.widthAnchor,constant:-20).isActive = true
        textview.anchor(top: topAnchor, left: nil, right: nil, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
       // textview.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: -10, paddingBottom: 0, width: 200, height: 0)
    }
    override func prepareForReuse() {
       // profileimageview.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
