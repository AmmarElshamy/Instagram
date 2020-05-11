//
//  PhotoSelectorController.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/8/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

    private let cellIdentifier = "Cell"
    private let headerIdentifier = "Header"
    private var images = [UIImage]()
    private var assets = [PHAsset]()
    private var selectedImageIndex: Int?
    private var header: PhotoSelectorCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // register header
        collectionView.register(PhotoSelectorCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // register Image Cell
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        
        setupNavigationButtons()
        
        fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action:
            #selector(handleNext))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        allPhotos.enumerateObjects { (asset, count, stop) in
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { (image, info) in
                
                if let image = image {
                    self.images.append(image)
                    self.assets.append(asset)
                    
                    if self.selectedImageIndex == nil {
                        self.selectedImageIndex = 0
                    }
                }
                
                if count == allPhotos.count - 1 {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
    
    func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        fetchOptions.fetchLimit = 10
        
        return fetchOptions
    }
    

}


// MARK: UICollectionViewDataSource and UICollectionViewDelegate

extension PhotoSelectorController {
    
    // Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    // Size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    // Horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Spacing between header and cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PhotoSelectorCell
        
        // Scale up selectedImage (600 * 600)
        if let selectedImageIndex = self.selectedImageIndex {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            header.photoImageView.image = self.images[selectedImageIndex]
            
            let selectedAsset = self.assets[selectedImageIndex]
                    
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: selectedAsset, targetSize: CGSize(width: 600, height: 600), contentMode: .default, options: nil) { (image, info) in
                
                header.photoImageView.image = image
            }
        }
        
        self.header = header
        return header
    }
    
    // Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    // Selected cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImageIndex = indexPath.item
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}

