//
//  ChatView.swift
//  Instragram20170417
//
//  Created by Nathan on 4/24/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class ChatView: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var messages = [Message]()
    var userid:String?{
        didSet{
            guard let userid = userid else {return}
            FIRDatabase.database().fetchuserpost(userid: userid) { (user) in
                self.navigationItem.title = user.username
            }
            
        }
    }
    var container:UIView = {
       let con = UIView()
        con.backgroundColor = UIColor.white
        return con
        
    }()
    var enterfild:UITextField = {
       let en = UITextField()
        en.placeholder = "Enter Text"
        en.autocapitalizationType = UITextAutocapitalizationType.none
        en.autocorrectionType = UITextAutocorrectionType.no
        return en
        
    }()
    var sepline:UIView = {
        let sep = UIView()
        
        sep.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return sep
        
    }()
    lazy var sendbutton:UIButton = {
       let send = UIButton(type: .system)
        send.setTitle("Send", for: .normal)
        send.setTitleColor(.white, for: .normal)
        send.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 230/255, alpha: 1)
        send.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        send.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        return send
        
    }()
    var containerbottomanchor: NSLayoutConstraint?
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        self.collectionView?.alwaysBounceVertical = true
        view.addSubview(container)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        containerbottomanchor = container.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        containerbottomanchor?.isActive = true
        container.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        container.addSubview(sendbutton)
        sendbutton.anchor(top: container.topAnchor, left: nil, right: container.rightAnchor, bottom: container.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 80, height: 0)
        container.addSubview(enterfild)
        enterfild.anchor(top: container.topAnchor, left: container.leftAnchor, right: sendbutton.leftAnchor, bottom: container.bottomAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        container.addSubview(sepline)
        sepline.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editdone)))
        loadmessage()
        setupkeyboardmove()

    }
    func editdone(){
        enterfild.resignFirstResponder()
    }
    func setupkeyboardmove(){
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardshow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handledidshow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardhide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func handlekeyboardshow(notification:Notification){
        guard let keyboardframe = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {return}
        guard let keyboardtime = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double else {return}
        containerbottomanchor?.constant = -keyboardframe.height
        
        //collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        UIView.animate(withDuration: keyboardtime) {
            self.view.layoutIfNeeded()
        }
        
    }
    func handledidshow(){
        if self.messages.count != 0 {
        let inpath = IndexPath(item: self.messages.count-1, section: 0)
        self.collectionView?.scrollToItem(at: inpath , at: .top, animated: true)
        }
    }
    func handlekeyboardhide(notification:Notification){
        containerbottomanchor?.constant = 0
        guard let keyboardtime = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double else {return}
       // collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: -(200)+8, right: 0)
        UIView.animate(withDuration: keyboardtime) {
            self.view.layoutIfNeeded()
        }
    }
    func loadmessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            FIRDatabase.database().reference().child("messages").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                let mess = Message(dictionary: dictionary)
                guard let uuid = self.userid else {return}
                let partnerid = mess.fromId == FIRAuth.auth()?.currentUser?.uid ? mess.toId : mess.fromId
                if partnerid == uuid{
                    self.messages.append(mess)
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                        let inpath = IndexPath(item: self.messages.count-1, section: 0)
                        self.collectionView?.scrollToItem(at: inpath , at: .top, animated: true)
                    }
                }
                
                
            }, withCancel: nil)

        })
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
    
        //cell.backgroundColor = .blue
        cell.message = messages[indexPath.item]
        if FIRAuth.auth()?.currentUser?.uid == messages[indexPath.item].fromId {
            cell.textview.textColor = UIColor.white
            cell.profileimageview.isHidden = true
            cell.bubbleview.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 200/255, alpha: 1)
            cell.bubbleviewleftanchor?.isActive = false
            cell.bubbleviewrightanchor?.isActive = true
            
        }
        else
        {
            cell.textview.textColor = UIColor.black
             cell.profileimageview.isHidden = false
            cell.bubbleview.backgroundColor = UIColor.lightGray
            cell.bubbleviewrightanchor?.isActive = false
            cell.bubbleviewleftanchor?.isActive = true
        }
        cell.bubbleviewwidthanchor?.constant  = NSString(string: messages[indexPath.item].text).boundingRect(with: CGSize(width:200,height:1000) , options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil).width + 32
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = NSString(string: messages[indexPath.item].text).boundingRect(with: CGSize(width:200,height:1000) , options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
        return CGSize(width: view.frame.width
            , height: size.height + 20)
    }
    func handlesend() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        guard let toid = userid
            else {return}
        let timestamp = Date().timeIntervalSince1970
        let childref = FIRDatabase.database().reference().child("messages").childByAutoId()
        childref.updateChildValues((["fromId":uid,"toId":toid,"text":enterfild.text,"timestampe":timestamp] as? [String:Any])!, withCompletionBlock: { (error, ref) in
            self.enterfild.resignFirstResponder()
            self.enterfild.text = nil
            FIRDatabase.database().reference().child("user-messages").child(uid).updateChildValues([childref.key:1])
            FIRDatabase.database().reference().child("user-messages").child(toid).updateChildValues([childref.key:1])
        })

    }

}
