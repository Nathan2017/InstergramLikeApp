//
//  Message.swift
//  Instragram20170417
//
//  Created by Nathan on 4/25/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

struct Message{
    let fromId:String
    let toId:String
    let text:String?
    let timestamp:Date
    let imageurl:String?
    let imageheight:CGFloat
    let imagewidth:CGFloat
    init(dictionary:[String:Any]) {
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? nil
        let timeago = dictionary["timestampe"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: timeago)
        self.imageurl = dictionary["imageurl"] as? String
            ?? nil
        self.imagewidth = dictionary["imagewidth"] as? CGFloat ?? 0
        self.imageheight = dictionary["imageheight"] as? CGFloat ?? 0
    }
}
