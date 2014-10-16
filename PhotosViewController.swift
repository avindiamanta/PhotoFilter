//
//  PhotosViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/15/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit
import Photos

protocol MyPhotosProtocol: class {
	func returnPhoto(image: UIImage)
}

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet weak var colectionView: UICollectionView!
	
	var assetFetchResult: PHFetchResult!
	var assetCollection: PHAssetCollection!
	var imageManager: PHCachingImageManager!
	var assetCellSize: CGSize!
	
	var flowLayout: UICollectionViewFlowLayout!
	
	var displayImageSize: CGSize!
	
	weak var delegate: MyPhotosProtocol?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.colectionView.delegate = self
		self.colectionView.dataSource = self
		
		self.imageManager = PHCachingImageManager()
		self.assetFetchResult = PHAsset.fetchAssetsWithOptions(nil)
		
		var scale = UIScreen.mainScreen().scale
		var flowLayout = self.colectionView.collectionViewLayout as UICollectionViewFlowLayout
		
		var cellSize = flowLayout.itemSize
		self.assetCellSize = CGSizeMake(cellSize.width, cellSize.height)
		
		var pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchCollectionView:")
		self.colectionView.addGestureRecognizer(pinchGesture)
		
		self.flowLayout = self.colectionView.collectionViewLayout as UICollectionViewFlowLayout
		
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.assetFetchResult.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = self.colectionView.dequeueReusableCellWithReuseIdentifier("PHOTO_CELL", forIndexPath: indexPath) as PhotoCollectionViewCell
		
		var currentTag = cell.tag + 1
		cell.tag = currentTag
		
		var asset = self.assetFetchResult[indexPath.row] as PHAsset
		self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
			if cell.tag == currentTag {
				cell.imageView.image = image
			}
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.imageManager.requestImageForAsset(self.assetFetchResult[indexPath.row] as PHAsset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
				self.delegate!.returnPhoto(image)
			}
		self.dismissViewControllerAnimated(true, completion: nil)	
	}
	
	func pinchCollectionView(gestureRecognizer: UIPinchGestureRecognizer) {
		if gestureRecognizer.state == UIGestureRecognizerState.Ended {
			self.colectionView.performBatchUpdates({ () -> Void in
				var currentSize = self.flowLayout.itemSize
				if gestureRecognizer.velocity < 0 {
					if currentSize.width < self.colectionView.bounds.width {
						self.flowLayout.itemSize = CGSize(width: currentSize.width * 2, height: currentSize.height * 2)
					}
				} else {
					if currentSize.width > 25.0 {
						self.flowLayout.itemSize = CGSize(width: currentSize.width * 1/2, height: currentSize.height * 1/2)
					}
				}
				}, completion: nil)
		}
	}
}

