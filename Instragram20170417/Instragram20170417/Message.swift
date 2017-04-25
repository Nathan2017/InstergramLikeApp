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
    let text:String
    let timestamp:Date
    init(dictionary:[String:Any]) {
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        let timeago = dictionary["timestampe"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: timeago)
    }
}
