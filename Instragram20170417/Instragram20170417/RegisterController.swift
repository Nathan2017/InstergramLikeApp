//
//  ViewController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class RegisterController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imageview:UIButton = {
       let iv = UIButton()
        let text = NSMutableAttributedString(string: "+", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40),NSForegroundColorAttributeName:UIColor.black])
        text.append(NSMutableAttributedString(string: "\n\nPhoto", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.black]))
        iv.setAttributedTitle(text, for: .normal)
        iv.titleLabel?.numberOfLines = 0
        iv.titleLabel?.textAlignment = .center
        iv.layer.masksToBounds = true
        iv.imageView?.contentMode = .scaleAspectFill
        iv.imageView?.clipsToBounds = true
       // iv.setTitleColor(UIColor.black, for: .normal)
        iv.layer.cornerRadius = 150/2
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 1
        iv.addTarget(self, action: #selector(addphoto), for: .touchUpInside)
        return iv
    }()
    lazy var goregisterlabel:UILabel = {
        let grb = UILabel()
        //grb.layer.cornerRadius = 5
        grb.text = "Already have a account ?"
        grb.textColor = UIColor.gray
        //grb.backgroundColor = UIColor.brown
        //grb.addTarget(self, action: #selector(goregister), for: .touchUpInside)
        return grb
    }()
    lazy var goregisterbutton:UIButton = {
        let grb = UIButton(type: .system)
        grb.backgroundColor = UIColor.clear
        grb.setTitle("Sign In", for: .normal)
        grb.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 1),for: .normal)
        grb.addTarget(self, action: #selector(gologin), for: .touchUpInside)
        return grb
    }()
    let emailtextfield:UITextField = {
       let etf = UITextField()
        etf.placeholder = "Email"
        etf.backgroundColor = UIColor.lightGray
        etf.layer.cornerRadius = 5
        etf.layer.borderWidth = 0.5
        etf.layer.borderColor = UIColor.gray.cgColor
        etf.autocorrectionType = UITextAutocorrectionType.no
        etf.autocapitalizationType = UITextAutocapitalizationType.none
        etf.addTarget(self, action: #selector(handleregisteronoff), for: .editingChanged)
        return etf
        
    }()
    let usernametextfield:UITextField = {
        let etf = UITextField()
        etf.placeholder = "Username"
        etf.backgroundColor = UIColor.lightGray
        etf.layer.cornerRadius = 5
        etf.layer.borderWidth = 0.5
        etf.layer.borderColor = UIColor.gray.cgColor
        etf.autocorrectionType = UITextAutocorrectionType.no
        etf.autocapitalizationType = UITextAutocapitalizationType.none
        etf.addTarget(self, action: #selector(handleregisteronoff), for: .editingChanged)
        return etf
    }()
    let passwordtextfield:UITextField = {
        let etf = UITextField()
        etf.placeholder = "Password"
        etf.backgroundColor = UIColor.lightGray
        etf.layer.cornerRadius = 5
        etf.layer.borderWidth = 0.5
        etf.layer.borderColor = UIColor.gray.cgColor
        etf.isSecureTextEntry = true
        etf.autocorrectionType = UITextAutocorrectionType.no
        etf.autocapitalizationType = UITextAutocapitalizationType.none
        etf.addTarget(self, action: #selector(handleregisteronoff), for: .editingChanged)
        return etf
        
    }()
    let registerbutton:UIButton = {
       let rg = UIButton(type: .system)
        rg.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 200/255, alpha: 1)
        rg.setTitle("Register", for: .normal)
        rg.setTitleColor(UIColor.white, for: .normal)
        rg.setTitleColor(UIColor.lightGray, for: .disabled)
        rg.layer.cornerRadius = 5
        rg.addTarget(self, action: #selector(handleregister), for: .touchUpInside)
        rg.isEnabled = false
        return rg
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(imageview)
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: topLayoutGuide.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 30, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailtextfield,usernametextfield,passwordtextfield,registerbutton])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.anchor(top: imageview.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 20, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: view.frame.width/1.5, height: 230)
        view.addSubview(goregisterlabel)
        goregisterlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goregisterlabel.anchor(top: nil, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0 , paddingLeft: 0, paddingRight: 0, paddingBottom: -10, width: 200, height: 30)
        view.addSubview(goregisterbutton)
        goregisterbutton.anchor(top: goregisterlabel.topAnchor, left: goregisterlabel.rightAnchor, right: nil, bottom: goregisterlabel.bottomAnchor, paddingTop: 0, paddingLeft: -15, paddingRight: 0, paddingBottom: 0, width: 70, height: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapscreen)))
        
    }
    func tapscreen(){
        usernametextfield.resignFirstResponder()
        emailtextfield.resignFirstResponder()
        passwordtextfield.resignFirstResponder()
    }
    func handleregisteronoff() {
        let formvalid = emailtextfield.text?.characters.count ?? 0 > 0 && usernametextfield.text?.characters.count ?? 0 > 0 && passwordtextfield.text?.characters.count ?? 0 > 0
        
        if formvalid {
            registerbutton.isEnabled = true
            registerbutton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 200/255, alpha: 1)
        }
        else
        {
            registerbutton.isEnabled = false
            registerbutton.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 200/255, alpha: 1)
        }
    }
    func addphoto(){
        let selectimage = UIImagePickerController()
        selectimage.delegate = self
        selectimage.allowsEditing = true
        present(selectimage, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageview.setImage(image, for: .normal)
        }
        else if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageview.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    func gologin(){
        self.navigationController?.popViewController(animated: true)
    }
    func handleregister(){
        guard let email = emailtextfield.text, emailtextfield.text?.characters.count ?? 0 > 0 else {return}
        guard let username = usernametextfield.text, usernametextfield.text?.characters.count ?? 0 > 0 else {return}
        guard let password = passwordtextfield.text, passwordtextfield.text?.characters.count ?? 0 > 0 else {return}
        emailtextfield.resignFirstResponder()
        usernametextfield.resignFirstResponder()
        passwordtextfield.resignFirstResponder()
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }
            print("Save user succesffuly")
            guard let id = user?.uid else {return}
            var dict:[String:Any] = ["username":username]
            guard let image = self.imageview.imageView?.image else {return}
            guard let imagedata = UIImageJPEGRepresentation(image, 0.3) else {return}
            let ranid = NSUUID().uuidString
            FIRStorage.storage().reference().child("profile_image").child(ranid).put(imagedata, metadata: nil, completion: { (data, error) in
                if let error = error {
                    print(error)
                    return
                }
                dict["profileimageurl"] = data?.downloadURL()?.absoluteString
                FIRDatabase.database().reference().child("users").child(id).setValue(dict, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                        return
                    }
                    print("Save DB Sucess")
                    guard let maintab = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else {return}
                    maintab.setupview()
                    self.dismiss(animated: true, completion: nil)
                })
            })
            
        })
        
    }

}

