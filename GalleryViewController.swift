//
//  GalleryViewController.swift
//  PhotoFilters
//
//  Created by Reid Weber on 10/13/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

protocol GalleryProtocol : class {
	func didTapOnItem(image: UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var images = [UIImage]()
	weak var delegate: GalleryProtocol?
	
	var flowLayout: UICollectionViewFlowLayout!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//		
//		let collectionViewLayout = UICollectionViewLayout()
//		collectionViewLayout.collectionView?.bounds = CGRectMake(0, 0, appDelegate.window!.frame.width, appDelegate.window!.frame.height)
//		self.collectionView.collectionViewLayout = UICollectionViewLayout()
		
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		var image1 = UIImage(named: "photo1.jpg")
		var image2 = UIImage(named: "photo2.jpg")
		var image3 = UIImage(named: "photo3.jpg")
		
		for (var i = 0; i < 10; i++) {
			self.images.append(image1)
			self.images.append(image2)
			self.images.append(image3)
		}
		
		self.flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
		
		var pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchCollectionView:")
		self.collectionView.addGestureRecognizer(pinchGesture)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.images.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as CollectionViewCell
		cell.imageView.image = self.images[indexPath.row]
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		println("Count: \(self.images.count)")
		self.delegate?.didTapOnItem(self.images[indexPath.row])
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func pinchCollectionView(gestureRecognizer: UIPinchGestureRecognizer) {
		if gestureRecognizer.state == UIGestureRecognizerState.Ended {
			self.collectionView.performBatchUpdates({ () -> Void in
				var currentSize = self.flowLayout.itemSize
				if gestureRecognizer.velocity < 0 {
						if currentSize.width < self.collectionView.bounds.width {
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
