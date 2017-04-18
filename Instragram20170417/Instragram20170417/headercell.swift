//
//  headercell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class headercell: UICollectionViewCell {
    let sepview:UIView = {
       let sv = UIView()
        sv.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        return sv
        
    }()
    let username:UILabel = {
        let username = UILabel()
        username.text = "Username"
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
        username.anchor(top: imageview.bottomAnchor, left: imageview.leftAnchor ,right: rightAnchor, bottom: nil, paddingTop: 12, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
