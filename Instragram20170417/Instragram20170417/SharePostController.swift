//
//  SharePostController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class SharePostController: UIViewController {
    var sharephoto:UIImage? {
        didSet{
            imageview.image = sharephoto
        }
    }
    let postview:UIView = {
       let pv = UIView()
        pv.backgroundColor = UIColor.white
        return pv
    }()
    let imageview:UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = UIColor.brown
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let usercaption:UITextView = {
       let usercaption = UITextView()
        usercaption.font = UIFont.systemFont(ofSize: 14)
        usercaption.autocorrectionType = UITextAutocorrectionType.no
        usercaption.autocapitalizationType = UITextAutocapitalizationType.none
        return usercaption
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleshare))
        view.addSubview(postview)
        postview.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 100)
        postview.addSubview(imageview)
        imageview.anchor(top: postview.topAnchor, left: postview.leftAnchor, right: nil, bottom: postview.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: -12, width: 100-16, height: 0)
        postview.addSubview(usercaption)
        usercaption.anchor(top: postview.topAnchor, left: imageview.rightAnchor, right: postview.rightAnchor, bottom: postview.bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, paddingBottom: -8, width: 0, height: 0)
    }
    func handleshare(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        let uid = NSUUID().uuidString
        guard let sharephoto = self.sharephoto else {return}
        guard let imagejpg = UIImageJPEGRepresentation(sharephoto, 0.3) else {return}
        FIRStorage.storage().reference().child("posts").child(uid).put(imagejpg, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Save Post Photo Success")
            guard let usercaption = self.usercaption.text else {return}
            var dict = ["postimageurl":metadata?.downloadURL()?.absoluteString,"postcaption":usercaption]
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
            FIRDatabase.database().reference().child("posts").child(uid).childByAutoId().setValue(dict, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                print("Successfully save to DB")
                self.dismiss(animated: true, completion: nil)
            })
        }
    }


}
