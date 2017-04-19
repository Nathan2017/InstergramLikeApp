//
//  PorfileShareImageCell.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
var imagecache = [String:UIImage]()
class PorfileShareImageCell: UICollectionViewCell {
    var post:Post? {
        didSet{
            guard let imageurl = post?.imageurl else {return}
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
                if url.absoluteString != self.post?.imageurl {
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
    let imageview:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        imageview.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    override func prepareForReuse() {
        imageview.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
