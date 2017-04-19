//
//  UserSearchCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/19/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class UserSearchCell: UICollectionViewCell {
    var user:User? {
        didSet{
            username.text = user?.username
            guard let imageurl = user?.imageurl else {return}
            loadimage2(imageurl: imageurl, view: imageview)
        }
    }
    let imageview:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.brown
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        return iv
        
    }()
    var username:UILabel = {
        let un = UILabel()
        //un.backgroundColor = UIColor.blue
        un.font = UIFont.boldSystemFont(ofSize: 14)
        return un
    }()
    let sepview:UIView = {
       let sepview = UIView()
        sepview.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        return sepview
        
    }()
    func loadimage2(imageurl:String,view:UIImageView){
        if let cacheimage = imagecache[imageurl] {
            
            view.image = cacheimage
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
                    view.image = image
                }
                
                }.resume()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageview.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 60, height: 60)
        addSubview(sepview)
        sepview.anchor(top: bottomAnchor, left: imageview.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        addSubview(username)
        username.anchor(top: imageview.topAnchor, left: imageview.rightAnchor, right: rightAnchor, bottom: imageview.bottomAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 0)
        
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
