//
//  CameraContainer.swift
//  Instragram20170417
//
//  Created by Nathan on 4/27/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Photos
class CameraContainer: UIView {
    let previewimageview:UIImageView = {
       let iv = UIImageView()
        
        return iv
    }()
    lazy var canbut:UIButton = {
        let canbut = UIButton(type: .system)
        canbut.setImage(#imageLiteral(resourceName: "cancelx").withRenderingMode(.alwaysOriginal), for: .normal)
        canbut.addTarget(self, action: #selector(handlecapturedphoto), for: .touchUpInside)
        return canbut
    }()
    lazy var savebutton:UIButton = {
        let canbut = UIButton(type: .system)
        canbut.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        canbut.addTarget(self, action: #selector(handlesave), for: .touchUpInside)
        return canbut
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewimageview)
        previewimageview.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        addSubview(canbut)
        canbut.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 50, height: 50)
        addSubview(savebutton)
        savebutton.anchor(top: nil, left: leftAnchor, right: nil, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 15, paddingRight: 0, paddingBottom: -15, width: 0, height: 0)
    }
    func handlecapturedphoto()
    {
        self.removeFromSuperview()
    }
    func handlesave(){
        guard let previewimage = previewimageview.image else {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({ 
            PHAssetChangeRequest.creationRequestForAsset(from: previewimage)
        }) { (success, error) in
            if let error = error {
                print(error)
                return
            }
            print("Save Success")
            DispatchQueue.main.async {
                let textlabel = UILabel()
                textlabel.text = "Save To Album Successfully"
                textlabel.textAlignment = .center
                textlabel.textColor = .white
                textlabel.numberOfLines = 0
                textlabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                textlabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                textlabel.center = self.center
                self.addSubview(textlabel)
                textlabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                    textlabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    textlabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    textlabel.alpha = 0
                    }, completion: { (_) in
                        
                       textlabel.removeFromSuperview()
                       
                    })
                    
                   }
                )
                
            }
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
