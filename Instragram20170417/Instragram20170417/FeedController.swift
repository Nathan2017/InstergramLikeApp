//
//  FeedController.swift
//  Instragram20170417
//
//  Created by Nathan on 4/18/17.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News Feed"
        collectionView?.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)


    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 12+40+12
        height += view.frame.width
        height += 100
        return CGSize(width: view.frame.width, height: height)
    }

}
