//
//  User.swift
//  Instragram20170417
//
//  Created by Nathan on 4/19/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
struct User{
    let username:String
    let imageurl:String
    let uid:String
    init(uid:String,dictionary:[String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.imageurl = dictionary["profileimageurl"] as? String ?? ""
        self.uid = uid
    }
}
