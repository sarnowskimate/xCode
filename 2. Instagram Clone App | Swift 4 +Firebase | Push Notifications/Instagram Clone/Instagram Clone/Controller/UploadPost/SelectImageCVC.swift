//
//  SelectImageVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "SelectPhotoCVCell"
private let headerIdentifier = "SelectPhotoHeaderCVCell"

class SelectImageCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    
    var images = [UIImage]()
    var phAssets = [PHAsset]()
    var selectedImage: UIImage?
    var header: SelectPhotoHeaderCVCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        collectionView.register(SelectPhotoCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SelectPhotoHeaderCVCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.backgroundColor = .white
        configureNavigationButtons()
        
        fetchPhotos()
    }
    
    //MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeaderCVCell
        
        self.header = header
        
        if let selectedImage = self.selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.phAssets[index]
                
                let imageManager = PHImageManager.default()
                
                let targetSize = CGSize(width: 600, height: 600)
                
                // request image
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: .none) { (image, info) in
                    header.photoImageView.image = image
                }
            }
        }
    
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPhotoCVCell
        
        cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    //MARK: - Handlers
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleNext() {
        print("Unfinished function: SelectImageCVC.swift -> handleNext()")
        let uploadPostVC = UploadPostVC()
        uploadPostVC.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(uploadPostVC, animated: true)
    }
    
    func configureNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func getAssetsFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        // fetch limit
        options.fetchLimit = 30
        
        // sort photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetsFetchOptions())
        
        // fetch images on background thread
        DispatchQueue.global(qos: .background).async {
            
            // enumerate objects
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                print("The count is \(count) now")
                
                let imageManaer = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // request image representation for specified asset
                imageManaer.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let safeImage = image {
                        
                        // append image to data source
                        self.images.append(safeImage)
                        
                        // append asset to data source
                        self.phAssets.append(asset)
                        
                        // set selected image with first image; on next iteration this block wont execute because it has a value already
                        if self.selectedImage == nil {
                            self.selectedImage = safeImage
                        }
                    
                    // reload collection view with images once count has completed
                        if count == allPhotos.count - 1 {
                            
                            // reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
