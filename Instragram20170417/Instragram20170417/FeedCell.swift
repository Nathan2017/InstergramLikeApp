//
//  FeedCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    let imageview:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.brown
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    let postimage:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.green
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let username:UILabel = {
       let un = UILabel()
        un.backgroundColor = UIColor.blue
        return un
    }()
    let caption:UITextView = {
       let cp = UITextView()
        cp.backgroundColor = UIColor.cyan
        
        return cp
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        imageview.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        addSubview(postimage)
        postimage.anchor(top: imageview.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: frame.width)
        addSubview(username)
        username.anchor(top: imageview.topAnchor, left: imageview.rightAnchor, right: rightAnchor, bottom: imageview.bottomAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 0)
        addSubview(caption)
        caption.anchor(top: postimage.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
