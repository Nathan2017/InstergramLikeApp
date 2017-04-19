//
//  PhotoCollectionViewController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Photos
private let reuseIdentifier = "Cell"
private let headerid = "headerid"
class PhotoCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var assetcollection = [PHAsset]()
    var photocollection = [UIImage]()
    var selectedimage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissview))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handlenext))
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(PhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerid)
        
        fetchphoto()
    }
    var head:PhotoHeaderCell?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerid, for: indexPath) as! PhotoHeaderCell
        if let selectimage = selectedimage {
            if let index = self.photocollection.index(of: selectimage){
                let selectedasset = self.assetcollection[index]

                    let manager = PHImageManager.default()
                
                    manager.requestImage(for: selectedasset, targetSize: CGSize(width:600,height:600), contentMode: .aspectFit, options: nil) { (image, info) in
                        guard let image = image else {return}
                             head.imageview.image = image
                        
                       
                        
                        }
                
                

            }
            
            
        }
        self.head = head
        return head
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photocollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.imageview.image = self.photocollection[indexPath.item]
    
        return cell
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func dismissview(){
        self.dismiss(animated: true , completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-5)/4
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 1)
    }
    func fetchphoto(){
        let fetchoption = PHFetchOptions()
        fetchoption.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchoption.sortDescriptors = [sortDescriptor]
        let photos = PHAsset.fetchAssets(with: .image, options: fetchoption)
        DispatchQueue.global(qos: .background).async {
            photos.enumerateObjects ({ (asset, count, stop) in
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                manager.requestImage(for: asset, targetSize: CGSize(width:200,height:200), contentMode: .aspectFit, options: option, resultHandler: { (image, info) in
                    if let image = image {
                        self.photocollection.append(image)
                        self.assetcollection.append(asset)
                    }
                    
                    
                     if self.selectedimage == nil {
                        
                     self.selectedimage = image
                     }
                })
                if count == photos.count - 1 {
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
            })
        }
        
    
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
        self.selectedimage = self.photocollection[indexPath.item]
        self.collectionView?.reloadData()
        
    }
    
    func handlenext(){
        let sharepost = SharePostController()
        sharepost.sharephoto = head?.imageview.image
        self.navigationController?.pushViewController(sharepost, animated: true)
    }

}
