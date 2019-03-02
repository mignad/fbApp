//
//  PhotosViewController.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 21/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoItems = [Photo]()
    var albumId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.getPhotos(for: albumId) { (result) in
            if let error = result.1 {
                self.showAlert(error.localizedDescription)
            } else {
                self.photoItems = result.0
                self.collectionView.reloadData()
            }
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        cell.descriptionLabel.text = photoItems[indexPath.row].text
        cell.photoImage.kf.setImage(with: URL(string:  photoItems[indexPath.row ].photoUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
            controller.selectedIndexPath = indexPath
            controller.photoItems = photoItems
            present(controller, animated: true, completion: nil)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width =  UIScreen.main.bounds.width / 4
            return CGSize(width: width, height: width + 35)
        }
    }
    
    @IBAction func actionPickerController(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerOriginalImage")] as? UIImage {
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
