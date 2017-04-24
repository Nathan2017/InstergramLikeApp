//
//  ChatCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/24/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    var user:User?{
        didSet{
            guard let imageurl = user?.imageurl else {return}
            guard let username = user?.username else {return}
            usernamelabel.text = username
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageview.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        addSubview(sepline)
        sepline.anchor(top: bottomAnchor, left: imageview.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        addSubview(usernamelabel)
        usernamelabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernamelabel.anchor(top: nil, left: imageview.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 15, paddingRight: 0, paddingBottom: 0, width: 0, height: 80)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
