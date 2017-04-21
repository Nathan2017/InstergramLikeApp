//
//  Post.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

struct Post {
    let imageurl:String
    let caption:String
    let user:User
    let date:Date
    init(user:User,dictionary:[String:Any]) {
        self.imageurl = dictionary["postimageurl"] as? String ?? "'"
        self.caption = dictionary["postcaption"] as? String ?? ""
        self.user = user
        let timeago = dictionary["creationdate"] as? Double ?? 0
        self.date = Date(timeIntervalSince1970: timeago)
    }
}
