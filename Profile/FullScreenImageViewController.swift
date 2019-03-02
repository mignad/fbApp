//
//  FullScreenImageViewController.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 25/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var photoItems = [Photo]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selected = selectedIndexPath {
            imageCollectionView.scrollToItem(at: selected, at: .centeredHorizontally, animated: false)
        }
    }
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension FullScreenImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenPhotoCollectionCell", for: indexPath) as! FullScreenPhotoCollectionCell
        cell.imageView.kf.setImage(with: URL(string: photoItems[indexPath.row ].photoUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}
