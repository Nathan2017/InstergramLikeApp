//
//  FeedCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    var post:Post?{
        didSet{
            caption.text = post?.caption
            username.text = post?.user.username
            guard let imageurl = post?.imageurl else {return}
            guard let userimageurl = post?.user.imageurl else {return}
            loadimage2(imageurl: userimageurl, view: imageview,domatch:false)
            loadimage2(imageurl: imageurl,view: postimage,domatch:true)
            
            
        }
    }
    let imageview:UIImageView = {
        let iv = UIImageView()
      
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
        
    }()
    let moreoptionbutton:UIButton = {
       let mpb = UIButton()
        mpb.setTitle("•••", for: .normal)
        mpb.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        mpb.setTitleColor(UIColor.black, for: .normal)
        return mpb
    }()
    let postimage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    var username:UILabel = {
       let un = UILabel()
        un.font = UIFont.boldSystemFont(ofSize: 14)
        return un
    }()
    let caption:UITextView = {
       let cp = UITextView()
        cp.backgroundColor = UIColor.clear
        cp.font = UIFont.systemFont(ofSize: 14)
        cp.isUserInteractionEnabled = false
        return cp
        
    }()
    func loadimage2(imageurl:String,view:UIImageView,domatch:Bool){
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
                if domatch {
                if url.absoluteString != self.post?.imageurl {
                    return
                }
                }
                else
                {
                    if url.absoluteString != self.post?.user.imageurl {
                        return
                    }
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
        imageview.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        addSubview(postimage)
        postimage.anchor(top: imageview.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: frame.width)
        addSubview(moreoptionbutton)
        moreoptionbutton.anchor(top: imageview.topAnchor, left: nil, right: rightAnchor, bottom: imageview.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 50, height: 0)
        addSubview(username)
        username.anchor(top: imageview.topAnchor, left: imageview.rightAnchor, right: moreoptionbutton.leftAnchor, bottom: imageview.bottomAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 0)
        addSubview(caption)
        caption.anchor(top: postimage.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 0)
        
    }
    override func prepareForReuse() {
        postimage.image = nil
        imageview.image = nil
        username.text = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
