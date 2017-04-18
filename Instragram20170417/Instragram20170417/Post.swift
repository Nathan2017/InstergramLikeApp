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
    init(dictionary:[String:Any]) {
        self.imageurl = dictionary["postimageurl"] as? String ?? "'"
    }
}
