//
//  LoginViewController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/17/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    let imageview:UIView = {
       let im = UIView()
        im.backgroundColor = UIColor(red: 200/255, green: 100/255, blue: 100/255, alpha: 1)
        return im
    }()
    lazy var goregisterlabel:UILabel = {
       let grb = UILabel()
        //grb.layer.cornerRadius = 5
        grb.text = "Dont have a account ?"
        grb.textColor = UIColor.gray
        //grb.backgroundColor = UIColor.brown
        //grb.addTarget(self, action: #selector(goregister), for: .touchUpInside)
        return grb
    }()
    lazy var goregisterbutton:UIButton = {
       let grb = UIButton(type: .system)
        grb.backgroundColor = UIColor.clear
        grb.setTitle("Sign Up", for: .normal)
        grb.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 1),for: .normal)
        grb.addTarget(self, action: #selector(goregister), for: .touchUpInside)
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
        etf.addTarget(self, action: #selector(handleloginonoff), for: .editingChanged)
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
        etf.addTarget(self, action: #selector(handleloginonoff), for: .editingChanged)
        return etf
        
    }()
    let registerbutton:UIButton = {
        let rg = UIButton(type: .system)
        rg.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 200/255, alpha: 1)
        rg.setTitle("Login", for: .normal)
        rg.setTitleColor(UIColor.white, for: .normal)
        rg.setTitleColor(UIColor.lightGray, for: .disabled)
        rg.layer.cornerRadius = 5
        rg.addTarget(self, action: #selector(handlelogin), for: .touchUpInside)
        rg.isEnabled = false
        return rg
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(imageview)
        imageview.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailtextfield,passwordtextfield,registerbutton])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.anchor(top: imageview.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 50, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: view.frame.width/1.5, height: 170)
        view.addSubview(goregisterlabel)
        goregisterlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goregisterlabel.anchor(top: nil, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0 , paddingLeft: 0, paddingRight: 0, paddingBottom: -10, width: 200, height: 30)
        view.addSubview(goregisterbutton)
        goregisterbutton.anchor(top: goregisterlabel.topAnchor, left: goregisterlabel.rightAnchor, right: nil, bottom: goregisterlabel.bottomAnchor, paddingTop: 0, paddingLeft: -30, paddingRight: 0, paddingBottom: 0, width: 70, height: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapscreen)))
    }
    func handleloginonoff() {
        let formvalid = emailtextfield.text?.characters.count ?? 0 > 0 && passwordtextfield.text?.characters.count ?? 0 > 0
        
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
    func tapscreen(){
        emailtextfield.resignFirstResponder()
        passwordtextfield.resignFirstResponder()
    }
    func goregister(){
        self.navigationController?.pushViewController(RegisterController(), animated: true)
    }
    func handlelogin(){
        guard let email = emailtextfield.text,emailtextfield.text?.characters.count ?? 0 > 0 else {return}
        guard let password = passwordtextfield.text,passwordtextfield.text?.characters.count ?? 0 > 0 else {return}
        emailtextfield.resignFirstResponder()
        passwordtextfield.resignFirstResponder()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }
            print("Login Success")
            guard let maintab = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else {return}
            maintab.setupview()
            self.dismiss(animated: true, completion: nil)
        })
    }



}
